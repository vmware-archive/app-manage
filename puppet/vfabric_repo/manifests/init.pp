## vfabric_repo module
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this repo require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
## to accept the EULA the variable "i_accept_eula" must be set to true
##
##

class vfabric_repo (
  $all = false,
  $ensure = installed,
  $i_accept_eula = false
  ) {
  $vfabric5_repo_url = 'http://repo.vmware.com/pub/rhel5/vfabric/5.3/vfabric-5.3-repo-5.3-1.noarch.rpm'
  $vfabric_all_repo_url = 'http://repo.vmware.com/pub/rhel5/vfabric-all/vfabric-all-repo-1-1.noarch.rpm'

  if $::osfamily == 'RedHat' and $i_accept_eula {
    package { 'vfabric-5.3-repo':
      ensure   => $ensure,
      provider => 'rpm',
      source   => $vfabric5_repo_url,
      before   => Exec['vfabric-eula-acceptance']
    }

    if $all {
      package { 'vfabric-all-repo':
        ensure   => $ensure,
        provider => 'rpm',
        source   => $vfabric_all_repo_url
      }
    }

    exec {'vfabric-eula-acceptance':
        command => '/etc/vmware/vfabric/vfabric-5.3-eula-acceptance.sh --accept_eula_file=VMware_EULA_20120515b_English.txt > /dev/null 2>&1',
        require => Package['vfabric-5.3-repo']
    }
  } elsif $::osfamily == 'Debian' {
    if $::operatingsystemrelease == '10.04' {
      fail "Operating System Release ${::operatingsystemrelease} not implemented yet"
    } elsif $::operatingsystemrelease == '12.04' {
      fail "Operating System Release ${::operatingsystemrelease} not implemented yet"
    } else {
      fail "Operating System Release ${::operatingsystemrelease} not supported"
    }
  } else {
      alert "[${::fqdn}] You must accept the terms of the EULA located at http://www.vmware.com/download/eula/vfabric_app-platform_eula.html"
  }
}

