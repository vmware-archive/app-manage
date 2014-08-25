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


# We need to override some of the defaults
node.override['rabbitmq']['version'] = "3.3.4"
node.override['rabbitmq']['package-release'] = "3"

case node['platform_family']
when 'debian'
  # For Ubuntu the Pivotal Package names are the same as the distro versions but on RHEL they have vfabric- in front of their names
  node.override['erlang']['install_method'] = 'esl'
  node.override['rabbitmq']['use_distro_version'] = "true"
when 'rhel'
  if (node['platform_version'].start_with?("5"))
    rhel = 5
  else
    rhel = 6
    node.override['yum']['erlang_solutions']['baseurl'] = 'http://packages.erlang-solutions.com/rpm/centos/6/$basearch'
  end
  if(node['kernel']['machine'] =~ /x86_64/)
    node.override['rabbitmq']['package'] = "http://packages.gopivotal.com/pub/rpm/rhel#{rhel}/app-suite/x86_64/pivotal-rabbitmq-server-#{node['rabbitmq']['version']}-#{node['rabbitmq']['package-release']}.noarch.rpm"
  end
end

