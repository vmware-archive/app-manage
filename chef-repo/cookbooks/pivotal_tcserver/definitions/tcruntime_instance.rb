
define :tcruntime_instance,
  :action => "start" do
  
  install_dir = node['pivotal_tcserver']['install_dir']

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
    args += " -p " +  params[:properties].join(" -p ")
  end

  cmd = "#{install_dir}/tcruntime-instance.sh"

  execute "create-instance" do
    command cmd + " create" + args
    creates "#{instance_dir}/params[:name]"
  end

  directory "#{instance_dir}/params[:name]" do
    
  end

  link "#{instance_dir}/#{params[:name]}/bin/init.d.sh" do
    to "/etc/init.d/tcserver-instance-#{params[:name]}"
  end

  service "tcserver-instance-#{params[:name]}" do
    supports :status => true
    action params[:action]
  end
end
