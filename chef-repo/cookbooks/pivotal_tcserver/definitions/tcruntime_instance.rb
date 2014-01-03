
define :tcruntime_instance,
  :action => "start",
  :user => "tcserver",
  :group => "vfabric" do
  
  install_dir = node['pivotal_tcserver']['install_dir']

  if params[:java_home]
    java_home = params[:java_home]
  else
    Chef::Application.fatal!("java_home must be set. No action taken.")
  end

  if params[:instance_dir] 
    instance_dir = params[:instance_dir]
  else
    instance_dir = install_dir
  end

  package node['pivotal_tcserver']['package'] do
    action :install
  end
  
  args  = " #{params[:name]}"
  args += " -i #{instance_dir}"
  args += " -v #{params[:version]}" if params[:version]
  args += " --layout #{params[:layout]}" if params[:layout]
  args += " --java-home #{params[:java_home]}" if params[:java_home]
  args += " --properties-file #{params[:properties_file]}" if params[:properties_file]

  if params[:templates]
    args += " -t " + params[:templates].join(" -t ")
  elsif params[:template]
    args += " -t #{params[:template]}"
  end

  if params[:properties]
    params[:properties].each do |p|
      p.each do |k,v|
        args +=" -p #{k}=#{v} "
      end
    end
  end

  cmd = "#{install_dir}/tcruntime-instance.sh"

  if params[:action] == :delete
    service "tcserver-instance-#{params[:name]}" do
      supports :status => true
      status_command "ps -p `cat #{install_dir}/#{params[:name]}/logs/tcserver.pid` > /dev/null 2>&1"
      action :stop
    end
    link "/etc/init.d/tcserver-instance-#{params[:name]}" do
      action :nothing
    end
    directory "#{instance_dir}/#{params[:name]}" do
      action :delete
      recursive true
    end
  else
  execute "create-instance" do
    environment ({ "JAVA_HOME" => "#{java_home}" })
    command cmd + " create" + args
    creates "#{instance_dir}/#{params[:name]}"
  end

  #Chef's directory resource does not recursive set ownership
  execute "set-ownership" do
    command "chown -R #{params[:user]}:#{params[:group]} #{instance_dir}/#{params[:name]}"
  end

  link "/etc/init.d/tcserver-instance-#{params[:name]}" do
    to "#{instance_dir}/#{params[:name]}/bin/init.d.sh" 
  end

  service "tcserver-instance-#{params[:name]}" do
    status_command "ps -p `cat #{install_dir}/#{params[:name]}/logs/tcserver.pid` > /dev/null 2>&1"
    supports :status => true
    action params[:action]
  end
  end
end
