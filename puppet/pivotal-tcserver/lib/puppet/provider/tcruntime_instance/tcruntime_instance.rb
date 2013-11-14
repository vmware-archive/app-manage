Puppet::Type.type(:tcruntime_instance).provide(:tcruntime_instance) do
  INSTANCE_TCRUNTIME_CTL = '/bin/tcruntime-ctl.sh'

  confine :true => true

  def self.instances
    Dir.entries(resource[:instances_root]) do |e|
      if Dir.exists(e) 
        if File.exists(e + INSTANCE_TCRUNTIME_CTL)
          puts "Adding #{e} as instance"
          new(:name => Dir.basename(e))
        else
          puts "Ignoring #{e} as instance"
        end
      end
    end
  end

  def create
    
    # We create the command here so we can get the java_home variable from the manifest
    resource = @resource
    Puppet::Provider.has_command(:tcruntime_instance, "/opt/vmware/vfabric-tc-server-standard/tcruntime-instance.sh" ) do
      environment :HOME => "/opt/vmware/vfabric-tc-server-standard/"
      environment :JAVA_HOME => resource[:java_home]
    end

    all_opts = " "
    if resource[:templates]
      template_opts = "-t " + resource[:templates].join(" -t ")
      puts "Template Opts: " + template_opts
      all_opts = all_opts + template_opts
    end
    
    if resource[:properties]
      property_opts = " "
      resource[:properties].each do |k,v|
        property_opts = property_opts + " -p #{k}=#{v} "
      end
      puts "Props: " + property_opts
      all_opts = all_opts + property_opts
    end

    if resource[:version]
      version_opt = "-v #{resource[:version]} "
      puts "Version: " + version_opt
      all_opts = all_opts + version_opt
    end

    if resource[:layout]
      layout_opt = "--layout #{resource[:layout]} "
      puts "Layout: " + layout_opt
      all_opts = all_opts + layout_opt
    end

    if resource[:properties_file]
      properties_file_opt = "-f #{resource[:properties_file]} "
      puts "Prop file: " + properties_file_opt
      all_opts = all_opts + properties_file_opt
    end
    puts all_opts
    tcruntime_instance('create', resource[:name], *all_opts.split(" "))
  end

  def exists?
    puts "Checking if #{resource[:name]} exists"
    File.exists?(resource[:instances_root]  + "/" + (resource[:name]))
  end
end

