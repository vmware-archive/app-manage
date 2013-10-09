## vFabric Web Server Puppet Module
##
## Copyright 2013 GoPivotal, Inc
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Configuration Information
##
##  $ensure
##    Default - installed
##    The state of the repository
##
##  $release
##    Default - '5.3'
##    The vFabric Release to use. This is only valid on RHEL/Yum based systems
##    Ubuntu doesn't require this to be specified
##
##  $i_accept_eula
##    Default - false
##    When true this indicates that the vFabric EULA is accepted which allows
##    the repository to be installed. 

class vfabric_repo (
  $ensure = installed,
  $release = '5.3',   #For YUM Repo
  $i_accept_eula = false
  ) {
  $vfabric5_repo_url = 'http://repo.vmware.com/pub/rhel5/vfabric/5.3/vfabric-5.3-repo-5.3-1.noarch.rpm'

  if $i_accept_eula {
    case $::operatingsystem {
      'RedHat', 'CentOS': {
        $org_name = 'vmware' # Red Hat YUM repo uses vmware
        $package_name = "vfabric-${release}-repo"
        $cmd = "/etc/${org_name}/vfabric/vfabric-${release}-eula-acceptance.sh --accept_eula_file=VMware_EULA_20120515b_English.txt > /dev/null 2>&1"
        $rhel_release = $::operatingsystemrelease ? {
          /^5/    => '5',
          /^6/    => '6',
          default => Fail["OS Release ${::operatingsystemrelease} not supported at this time"]
        }
        $vfabric_repo_url = "http://repo.vmware.com/pub/rhel${rhel_release}/vfabric/${release}/vfabric-${release}-repo-${release}-1.noarch.rpm"
        $vfabric_gpg_url = "http://repo.vmware.com/pub/rhel${rhel_release}/vfabric/${release}/RPM-GPG-KEY-VFABRIC-${release}-EL${rhel_release}"
        exec { 'gpg_import':
          command => "/bin/rpm --import ${vfabric_gpg_url}",
          creates => "/etc/pki/rpm-gpg/RPM-GPG-KEY-VFABRIC-${release}-EL${rhel_release}"
        } ->
        # The Repo RPM installs the acceptance script so instead of maintaining the repo with a yumrepo resource we have to install
        # the rpm ourselves.
        package { $package_name:
          ensure   => $ensure,
          provider => 'rpm',
          source   => $vfabric_repo_url,
          before   => Exec['vfabric-eula-acceptance']
        }
      }
      'Ubuntu': {
        $org_name = 'pivotal' # Ubuntu apt repo uses pivotal
        $vfabric_repo_package_gpgurl = 'http://packages.gopivotal.com/pub/apt/ubuntu/DEB-GPG-KEY-VFABRIC'
        $cmd = "/etc/${org_name}/vfabric/vfabric-eula-acceptance.sh --accept_eula_file=VMware_EULA_20120515b_English.txt > /dev/null 2>&1"
        $vfabric_repo_package_url = $::operatingsystemrelease ? {
          /^10.04/ => 'http://packages.gopivotal.com/pub/apt/ubuntu/vfabric-repo-lucid_1.0-5_all.deb',
          /^12.04/ => 'http://packages.gopivotal.com/pub/apt/ubuntu/vfabric-repo-precise_1.0-5_all.deb',
          default  => Fail["OS Release ${::operatingsystemrelease} not supported at this time"]
        }
        $package_name = $::operatingsystemrelease ? {
          /^10.04/ => 'vfabric-repo-lucid',
          /^12.04/ => 'vfabric-repo-precise'
        }
        apt::key {'vfabric':
          key_source => 'http://packages.gopivotal.com/pub/apt/ubuntu/DEB-GPG-KEY-VFABRIC'
        } ->
        wget::fetch { $vfabric_repo_package_url :
          destination => "/tmp/${package_name}",
          timeout     => 0,
          verbose     => false,
        } ->
        package { $package_name:
          ensure   => $ensure,
          provider => 'dpkg',
          source   => "/tmp/${package_name}",
          before   => Exec['vfabric-eula-acceptance']
        }
      }
      default: {
        fail "OS ${::operatingsystem} not supported at this time"
      }
    }
    exec { 'vfabric-eula-acceptance':
      command => $cmd,
      require => Package[$package_name]
    }
  } else {
    fail "[${::fqdn}] You must accept the terms of the EULA located at http://www.vmware.com/download/eula/vfabric_app-platform_eula.html"
  }
}
