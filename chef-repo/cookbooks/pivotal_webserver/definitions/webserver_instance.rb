## Copyright 2013-2014 Pivotal Software, Inc
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

define :webserver_instance,
  :action => "start".to_sym,
  :rootdir => "/opt/pivotal/webserver" do

  package node['pivotal_webserver']['package'] do
    action :install
  end

  args = " --quiet #{params[:name]}"
  args += " --set ServerAdmin=#{params[:server_admin]}" if params[:server_admin]
  args += " --set User=#{params[:user]}" if params[:user]
  args += " --set Group=#{params[:group]}" if params[:group]
  args += " --set Port=#{params[:port]}" if params[:port]
  args += " --set SSLPort=#{params[:ssl_port]}" if params[:ssl_port]
  args += " --set Hostname=#{params[:hostname]}" if params[:hostname]
  args += " --overlay" if params[:overlay]
  args += " --serverdir=#{params[:serverdir]}" if params[:serverdir]
  args += " --mpm=#{params[:mpm]}" if params[:mpm]
  args += " --httpdver=#{params[:httpdver]}" if params[:httpdver]
  args += " --sourcedir=#{params[:sourcedir]}" if params[:sourcedir]
  args += " --rootdir=#{params[:rootdir]}"

  serverdir = params[:serverdir] ? params[:serverdir] : params[:name]

  if params[:action] == :delete
    service "vFabric-httpd-#{params[:name]}" do
      supports :status => true
      action :stop
      status_command "ps -p `cat #{params[:rootdir]}/#{serverdir}/logs/httpd.pid` > /dev/null 2>&1"
      notifies :delete, "directory[#{params[:rootdir]}/#{serverdir}]", :immediately
    end

    directory "#{params[:rootdir]}/#{serverdir}" do
      recursive true
      action :nothing
      notifies :delete, "link[/etc/init.d/vFabric-httpd-#{params[:name]}]", :immediately
    end

    link "/etc/init.d/vFabric-httpd-#{params[:name]}" do
      action :nothing
    end
  else
    execute "run-newserver" do
      command "/opt/pivotal/webserver/newserver #{args}"
      creates "#{params[:rootdir]}/#{serverdir}"
    end
    
    link "/etc/init.d/pivotal-httpd-#{params[:name]}" do
      to "#{params[:rootdir]}/#{serverdir}/bin/httpdctl"
    end

    service "pivotal-httpd-#{params[:name]}" do
      supports :status => true
      status_command "ps -p `cat #{params[:rootdir]}/#{serverdir}/logs/httpd.pid` > /dev/null 2>&1"
      action params[:action]
    end

  end

end
