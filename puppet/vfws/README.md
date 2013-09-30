# Pivotal vFabric Web Server Module for Puppet

This README covers the initial release of the vFabric Web Server module for puppet. This README assumes the reader has a basic understanding of puppet and vFabric Web Server.

# About this module

This module installs vfabric-web-server from the vFabric YUM Repo and manages instances. It is important to note that this module uses the newserver command to create the instances. This means that if a configuration variable changes in a manifest that it will not be reflected in the instance unless it is destroyed first and allowed to be recreated.

# Example Usage

*Default options on port 8000* - The following example will install vFabric Web Server and create an instance called myserver on port 8000

```puppet

  include vfws

  vfws::instance { 'myserver':
    port => '8000',
  }

```


*More Options* - The following example will install vFabric Web Server and create an instance called myserver on port 8081 and using workers
```puppet

  include vfws
  
  vfws::instance { 'myserver':
    port => '8081',
    mpm => 'worker'
  }

```

# Configuration Variables

See init.pp and instance.pp for configuration options

