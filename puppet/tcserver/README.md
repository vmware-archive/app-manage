# Pivotal tc Server Module for Puppet

This README covers the initial release of the tc Server module for puppet. This README assumes the reader has a basic understanding of puppet and tc Server.

# About this module

This module will install tc Server to the target node(s) from the vFabric Repository. It is important to note that this module uses the tcruntime-instace create command to create the instances. This means that if a configuration variable changes in a manifest that it will not be reflected in the instance unless it is destroyed first and allowed to be recreated.

# Example Usage

*Basic usage* - The following example will install tc Server and create an instance called myinstance using all the defaults

```puppet
node 'default' {
  include tcserver    # Include the base tcserver class. This will automatically install tc Server using the defaults

  tcserver::instance {'myinstance':
  }

}
```


*Advanced usage* - Multiple instances.

```puppet
node 'default' {

  class {'tcserver':
  }

  tcserver::instance {'default_properties':
  }

  tcserver::instance {'special_ports':
    bio_http_port => 8081,
    bio_https_port => 8444,
    base_jmx_port => 6970,
    deploy_apps => true,
    ensure => running
  }

}
```

# Configuration Variables

See init.pp and instance.pp for variable details

