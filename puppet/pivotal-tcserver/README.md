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

## Templates and Properties

You may specify multiple templates via the "templates" configuration variable. It takes them in the form of a comma separated list enclosed in square brackets \[ \]. Example:

```puppet
  template => ['nio',  'nio-ssl'],
```

By default if there are custom templates located on the puppet master's tcserver module files directory(puppet:///modules/tcserver/templates) they will be copied to the node for use. This behavior can be turned off at the class level with

```puppet
  class {'tcserver':
    uses_templates => false,
  }
```

Properties may also be specified as an array in the form of \['key' => 'value'\]. Example:

```puppet
    properties  => [['bio-ssl.https.port' => '8444'], ['bio.http.port' => '8081']],
```

At this time the module does not support changing templates or properties on an existing template.

# Example Usage

*Basic usage* 
=============
The following example will install tc Server and create an instance called myinstance using all the defaults



```puppet
node 'default' {

  # Creates a single instance named myinstance
  tcserver::instance {'myinstance':
    java_home => '/opt/java/jdk7',
  }

}
```

*Advanced usage*
================
The following example will create multiple instances
```puppet
node 'default' {
 
  # This creates an instance named default_properties and sets the java_home used to create the instance to /opt/java/jdk7
  tcserver::instance {'default_properties':
    java_home    => '/opt/java/jdk7',
  }

  # This creates a second instance named special_ports, deploys the contents of webapps from the puppet master to the instance,
  # ensures that the instance is running, and sets the java home. 
  tcserver::instance {'special_ports':
    properties   => [['bio-ssl.https.port' => '8444'], ['bio.http.port' => '8081']],
    deploy_apps  => true,
    java_home    => '/opt/java/jdk6'
  }

}
```

Template
========
The following example will create an instance using templates

```puppet

  # Creates an instance named custom-templates using the templates 'nio' and 'nio-ssl'
  tcserver::instance {'custom-templates':
    templates    => ['nio',  'nio-ssl'],
    java_home    => '/opt/java/jdk6',
  }
```

Removing Instances
==================

You can use the absent value to ensure to remove instances. This does not uninstall any packages. 

```puppet
  tcserver::instance {"myinstance":
    ensure      => absent,
}
```

When all the instances are removed you can remove the .rpm/.deb by specifying absent for the class. 

```puppet

  class {'tcserver':
    ensure => absent
  }
```

# License Information

This module is licensed under Apache 2.0 license

tc Server is licensed under the [tc Server EULA](http://www.vmware.com/download/eula/universal_eula.html).

# Configuration Variables

See [init.pp](https://github.com/pivotal/app-manage/raw/master/puppet/pivotal-tcserver/manifests/init.pp) and [instance.pp](https://github.com/pivotal/app-manage/raw/master/puppet/pivotal-tcserver/manifests/instance.pp) for variable details

