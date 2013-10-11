# IMPORTANT NOTICE

This github repository contains code which is currently in development. Please do not distribute to customers, PoCs, or other 3rd parties. The code contained in this repo is subject to breakage.

# Pivotal/vFabric Puppet Modules

These modules are provided to simplify the installation of vFabric/Pivotal products.  They may be used together or separately. Tested with puppet 3.x.

# Before you begin

 * These modules are only supported for RHEL 5/6 and Ubuntu 10.04/12.04.
 * Some modules depend on other modules from puppet forge please see READMEs for each module for requirements 

# Installation 

To install these modules copy each directory recursively into /etc/puppet/modules.

# Example site.pp

The following example shows basic usage and includes all modules

```puppet
node 'default' {
  class {'vfabric_repo':
    i_accept_eula => true
  }

  include tcserver

  tcserver::instance {'myinstance':
    bio_http_port => 8081,
    ensure => 'running'
  }

  include vfws

  vfws::instance { 'myserver':
    port => 8082,
    overlay => true,
    mpm => 'prefork',
  }
}


```
