# Pivotal vFabric Web Server Module for Puppet

This README covers the initial release of the vFabric Web Server module for puppet. This README assumes the reader has a basic understanding of puppet and vFabric Web Server.

# About this module

This module will install vFabric Web Server to the target node(s). It requires that a copy of the installation media be located on the puppet master or the vfabric\_repo puppet module to be used. It is important to note that this module uses the newserver command to create the instances. This means that if a configuration variable changes in a manifest that it will not be reflected in the instance unless it is destroyed first and allowed to be recreated.

# Example Usage

*Default options on port 8000* - The following example will install vFabric Web Server and create an instance called myserver on port 8000

```puppet

  include vfws

  vfws::instance { "myserver":
    port => "8000",
  }

```


*More Options* - The following example will install vFabric Web Server and create an instance called myserver on port 8081 and using workers
```puppet

  include vfws
  
  vfws::instance { "myserver":
    port => "8081",
    mpm => "worker"
  }

```

# Configuration Variables

##vFabric Web Server Base

**vfws_version** - The version, including archetecture and os/libc version. Default:  "5.3.1-2-x86_64-linux-glibc2"

**install_path** - The location to install vfws. Default:  "/opt/vmware"

## vFabric Web Server Instance

**ensure** - The state of the instance valid options are "running", "stopped", "absent". Default: "running"

**admin_email** - The value of AdminEmail. Default:  undefined
**sslport** - The value of SSLPort. Default:  undefined
**user** - The value of the User configuration option. Default: undefined
**group** - The value of the Group configuration option. Default: undefined
**port** - The value of the Port configuration option. Default: undefined
**hostname** - The value of Hostname configuration option. Default: undefined
**base_dir** - The base directory of the instance. Default: undefined
**overlay** - Whether to overlay an existing instance. Default: false
**serverdir** - The value to pass to --serverdir option. Default: undefined
**mpm** - The value of the --mpm option. Default: undefined
**httpdver** - The value of --httpdver. Default: undefined
**sourcedir** = The value of --sourcedir. Default: undefined


