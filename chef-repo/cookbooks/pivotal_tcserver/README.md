pivotal_tcserver Cookbook
=========================
This cookbook provides a definition which installs vFabric tc Server and creates runtime instances.



Requirements
------------
#### cookbooks
- `pivotal_repo` - This is needed to install the Pivotal/vFabric package repositorya
- A JDK already installed.
- /bin/sh should point to bash. On some systems, especially Ubuntu, /bin/sh points to a different shell. This is a requirement for tcruntime-instance.sh to run correctly.

Configuration
-------------
||name||definition
|java_home|The value to set JAVA_HOME environment variable to when invoking tcruntime-instance.sh (Required)
|instance_dir|The root directory to create the instance in. This defaults to the base path of tcruntime-instance.sh script (Optional)
|version|The value to give the --version argument. (Optional)
|layout|The value to give the --layout argument. (Optional)
|templates|An array of templates to use. (Optional)
|properties|An array of properties to pass to tcruntime-instance.sh (Optional)

Usage
-----
Your cookbook should depend on 'pivotal_webserver'

metadata.rb:
```ruby
depends `pivotal_webserver`
```
You must set java_home to point to a valid JDK installation on the target system.

```ruby
tcruntime_instance "test1" do
  java_home "/usr/java"
end

```

Example of properties and templates
```ruby
tcruntime_instance "tcruntime-8081" do
  java_home "/usr"
  properties [{'bio.http.port' => '8081'}, {'bio.httpS.port' => '8444'}, {'base.jmx.port' => '6970'}]
  templates ['bio',  'bio-ssl']
end
```

License
-------
This cookbook is licensed under the Apache 2.0 License. It uses software which is licensed under commercial licenses.


