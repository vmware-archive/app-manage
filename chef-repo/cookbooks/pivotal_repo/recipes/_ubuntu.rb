## Ubuntu specific recipe
##
## Copyright 2013 Pivotal Software, Inc
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

remote_file "#{Chef::Config[:file_cache_path]}/#{node['pivotal_repo']['package']}" do
  source node['pivotal_repo']['url']
  action :create_if_missing
  notifies :run, "execute[import-key]", :immediately
end

execute "import-key" do
  command "wget -q -O - http://packages.pivotal.io/pub/apt/ubuntu/DEB-GPG-KEY-PIVOTAL-APP-SUITE | apt-key add -"
  notifies :run, "execute[apt-update]", :immediately
  action :nothing
end

execute "apt-update" do
  command "apt-get update"
  action :nothing
  notifies :install, "dpkg_package[#{node['pivotal_repo']['package']}]", :immediately
end

dpkg_package node['pivotal_repo']['package'] do
  source "#{Chef::Config[:file_cache_path]}/#{node['pivotal_repo']['package']}"
  only_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/#{node['pivotal_repo']['package']}") }
  action :install
  notifies :run, "execute[import-key]", :immediately
end

bash "accept_eula" do
  code node['pivotal_repo']['eula_accept_cmd']
  creates node['pivotal_repo']['eula_accepted_file']
  action :run
end

