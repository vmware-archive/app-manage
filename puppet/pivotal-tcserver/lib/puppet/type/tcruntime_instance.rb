Puppet::Type.newtype(:tcruntime_instance) do
  desc 'manages tcruntime instances'

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
#    newvalue(:absent) do
#      provider.destroy
#    end
  end

  newparam(:name, :namevar => true) do
    'name of the instance'
    newvalues(/^\S+$/)
  end

  newparam(:templates) do
    'hash of templates to use'
  end

  newparam(:properties) do
    'hash of properties to use'
  end

  newparam(:instance_directory) do
    'root directory to create instances in'

    defaultto "/var/opt/pivotal/pivotal-tc-server-standard/"
  end

  newparam(:use_java_home) do
    'whether to use --java-home with tcruntime-instance'
    
    defaultto :false
  end
  
  newparam(:version) do
    'the version of tomcat to use'

  end
  
  newparam(:layout) do
    'the option to --layout to use'  
  end
  
  newparam(:properties_file) do
    'the value of --properties-file'
  end  

  newparam(:java_home) do
     'path to use for JAVA_HOME environment variable'

     defaultto do
       if Facter.value(:env_java_home)
         Facter.value(:env_java_home)
       else
         "/usr"
       end
     end
   end
 
end

