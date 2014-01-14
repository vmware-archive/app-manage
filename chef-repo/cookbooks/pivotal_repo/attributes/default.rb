## Copyright 2014 GoPivotal, Inc
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
#

case node['platform_family']
when 'rhel'
  if node['platform_version'].start_with?('5')
    rhel_version = 5
  elsif node['platform_version'].start_with?('6')
    rhel_version = 6
  end
  default['pivotal_repo']['package'] = "vfabric-5.3-repo-5.3-1.noarch.rpm"
  default['pivotal_repo']['url'] = "http://packages.gopivotal.com/pub/rpm/rhel#{rhel_version}/vfabric/5.3/#{node['pivotal_repo']['package']}"
  default['pivotal_repo']['gpg_url'] = "http://packages.gopivotal.com/pub/rpm/rhel#{rhel_version}/vfabric/5.3/RPM-GPG-KEY-VFABRIC-5.3-EL#{rhel_version}"
  default['pivotal_repo']['eula_accept_cmd'] = "/etc/vmware/vfabric/vfabric-5.3-eula-acceptance.sh --accept_eula_file=VMware_EULA_20120515b_English.txt > /dev/null 2>&1"
  default['pivotal_repo']['eula_accepted_file'] = "/etc/vmware/vfabric/accepted-VMware_EULA_20120515b_English.txt"
when 'debian'
  if node['platform_version'] == '10.04'
    default['pivotal_repo']['package'] = "vfabric-repo-lucid_1.0-6_all.deb"
  elsif node['platform_version'] == '12.04'
    default['pivotal_repo']['package'] = "vfabric-repo-precise_1.0-6_all.deb"
  end
  default['pivotal_repo']['url'] = "http://packages.gopivotal.com/pub/apt/ubuntu/#{node['pivotal_repo']['package']}"
  default['pivotal_repo']['eula_accept_cmd'] = "/etc/pivotal/vfabric/vfabric-eula-acceptance.sh --accept_eula_file=VMware_EULA_20120515b_English.txt > /dev/null 2>&1"
  default['pivotal_repo']['eula_accepted_file'] = "/etc/pivotal/vfabric/accepted-VMware_EULA_20120515b_English.txt"
end

