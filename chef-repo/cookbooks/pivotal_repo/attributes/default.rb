## Copyright 2014 Pivotal Software, Inc
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
  default['pivotal_repo']['package'] = "app-suite-repo-1.0-4.noarch.rpm"
  default['pivotal_repo']['url'] = "http://packages.gopivotal.com/pub/rpm/rhel#{rhel_version}/app-suite/#{node['pivotal_repo']['package']}"
  default['pivotal_repo']['gpg_url'] = "http://packages.gopivotal.com/pub/rpm/rhel#{rhel_version}/vfabric/5.3/RPM-GPG-KEY-VFABRIC-5.3-EL#{rhel_version}"
  default['pivotal_repo']['eula_accept_cmd'] = "/etc/pivotal/pivotal-eula-acceptance.sh --accept_eula_file=Pivotal_EULA.txt > /dev/null 2>&1"
  default['pivotal_repo']['eula_accepted_file'] = "/etc/pivotal/accepted-Pivotal_EULA.txt"
when 'debian'
  if node['platform_version'] == '10.04'
    default['pivotal_repo']['package'] = "pivotal-app-suite-repo-lucid_1.0-5_all.deb"
  elsif node['platform_version'] == '12.04'
    default['pivotal_repo']['package'] = "pivotal-app-suite-repo-precise_1.0-5_all.deb"
  end
  default['pivotal_repo']['url'] = "http://packages.pivotal.io/pub/apt/ubuntu/#{node['pivotal_repo']['package']}"
  default['pivotal_repo']['eula_accept_cmd'] = "/etc/pivotal/app-suite/pivotal-eula-acceptance.sh --accept_eula_file=Pivotal_Software_EULA--8.4.14.txt > /dev/null 2>&1"
  default['pivotal_repo']['eula_accepted_file'] = "/etc/pivotal/app-suite/accepted-Pivotal_Software_EULA--8.4.14.txt"
end

