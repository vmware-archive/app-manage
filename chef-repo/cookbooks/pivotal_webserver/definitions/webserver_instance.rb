

define :webserver_instance,
  :action => "start",
  :rootdir => "/opt/vmware/vfabric-web-server" do

  package node['pivotal_webserver']['package'] do
    action :install
  end

  args = " --quiet #{params[:name]}"
  args += " --set AdminEmail=#{params[:admin_email]}" if params[:admin_email]
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
      action "stop"
    end

    directory "#{params[:rootdir]}/#{serverdir}" do
      recursive true
      action :delete
    end

    link "/etc/init.d/vFabric-httpd-#{params[:name]}" do
      action :delete
    end
  else
    execute "run-newserver" do
      command "/opt/vmware/vfabric-web-server/newserver #{args}"
      creates "#{params[:rootdir]}/#{serverdir}"
    end
    
    link "/etc/init.d/vFabric-httpd-#{params[:name]}" do
      to "#{params[:rootdir]}/#{serverdir}/bin/httpdctl"
    end

    service "vFabric-httpd-#{params[:name]}" do
      action params[:action]
    end

  end

end
