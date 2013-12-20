## RHEL specific recipe
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

execute "import-gpgkey" do
  command "rpm --import #{node['pivotal_repo']['gpg_key']}"
end

execute "install-repo" do
  command "rpm -Uvh #{node['pivotal_repo']['package']}"
end

execute "accept-eula" do
  command node['pivotal_repo']['eula_accept_cmd']
  creates node['pivotal_repo']['eula_accepted_file']
  action :run
end

