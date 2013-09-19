# Pivotal/vFabric Puppet Modules

These modules are provided to simplify the installation of vFabric/Pivotal products.  They may be used together or separately. Tested with puppet 3.x

# Example site.pp

The following example shows basic usage and includes all modules

```puppet
node 'default' {
  class {'vfabric_repo':
    i_accept_eula => true
  }

  include tcserver

  tcserver::instance {"myinstance":
    bio_http_port => "8081",
    ensure => "running"
  }

  include vfws

  vfws::instance { "myserver":
    port => "8082",
    overlay => "true",
    mpm => "prefork",
  }
}


```
