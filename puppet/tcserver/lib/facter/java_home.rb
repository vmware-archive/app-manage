if ENV["JAVA_HOME"]
  Facter.add("env_java_home".to_sym) do 
    setcode do 
      ENV["JAVA_HOME"] 
    end
  end
end
