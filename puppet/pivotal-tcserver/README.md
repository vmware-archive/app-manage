# Pivotal tc Server Module for Puppet

This README covers the initial release of the tc Server module for puppet. This README assumes the reader has a basic understanding of puppet and tc Server.

# About this module

This module will install tc Server to the target node(s) from the Pivotal Package Repository(APT/YUM). It is important to note that this module uses the tcruntime-instance create command to create the instances. This means that if a configuration variable changes in a manifest that it will not be reflected in the instance unless it is destroyed first and allowed to be recreated.

At this time only a single template is supported. 

# Important information about JAVA\_HOME

This module will look for an environment variable named JAVA\_HOME if the java\_home configuration variable isn't set for the instance. The JAVA\_HOME environment variable should be present for the user running the puppet agent prior to invoking the puppet agent. 

# Before you begin

This module depends on the pivotal\_repo module 

tc Server requires a working java installation. Installation of java is beyond the scope of this module.

# Example Usage

*Basic usage* - The following example will install tc Server and create an instance called myinstance using all the defaults

```puppet
node 'default' {

  # Creates a single instance named myinstance
  tcserver::instance {'myinstance':
    java_home => '/opt/java/jdk7'
  }

}
```

*Advanced usage* - Multiple instances.

```puppet
node 'default' {
 
  # This creates an instance named default_properties and sets the java_home used to create the instance to /opt/java/jdk7
  tcserver::instance {'default_properties':
    java_home    => '/opt/java/jdk7'
  }

  # This creates a second instance named special_ports, deploys the contents of webapps from the puppet master to the instance,
  # ensures that the instance is running, and sets the java home. 
  tcserver::instance {'special_ports':
    properties   => [['bio-http-port' => '8080'], ['bio-ssl-port' => '8443']]
    deploy_apps  => true,
    java_home    => '/opt/java/jdk6'
  }

}
```

*Templates* - This will copy "mytemplate" placed in modules/tcserver/files/templates on the puppet master and will create the instance with "-t mytemplate".  Due to the way the instances are managed changing templates on an existing instance configuration will not actually change the template. 

```puppet

  # Creates an instance named custom-templates using the templates 'nio' and 'nio-ssl'
  tcserver::instance {'custom-templates':
    templates    => ['nio',  'nio-ssl'],
    java_home    => '/opt/java/jdk6',
  }
```

# License Information

This module is licensed under Apache 2.0 license

# Configuration Variables

See init.pp and instance.pp for variable details

