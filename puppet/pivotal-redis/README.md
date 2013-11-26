# Pivotal Redis Module for Puppet

This README covers the initial release of the Pivotal's Redis module for puppet. This README assumes the reader has a basic understanding of puppet and Redis.

# About this module

This module installs redis from the Pivotal Package Repository (APT/YUM). Currently only RHEL 5 & 6, Ubuntu 10.04 & 12.04 are supported. 

# Before you begin

This module depends on the pivotal\_repo module

# Example Usage

The following will install Pivotal Redis and configure 2 instances on the same node.
```puppet
  redis {'redis-9001':
    ensure => running,
    listen_port => '9001'
  }

  redis {'redis-9002':
    listen_port => '9002'
  }

```

The following will install Pivotal Redis with a master-slave replication config on the same node and include authentication. In redis 2.6 the default is for slaves to be read-only.
```puppet
  redis {'master-9001':
    listen_port  => '9001',
    requirepass  => 'mycoolpassword',
  }

  redis {'slave-9002':
    listen_port  => '9002',
    masterauth   => 'mycoolpassword',
    slaveof      => '127.0.0.1 9001'
  }
```

The following will tell redis to bind to '127.0.0.1' only.

```puppet
  redis {'master-9001':
    listen_port    => '9001',
    listen_address => '127.0.0.1',
    requirepass    => 'mycoolpassword',
  }
```

On some systems (Ubuntu) the .deb package installed by puppet automatically starts an instance on port 6379. If you're not using that port you can tell puppet to stop or remove the config. The following will remove the config for that port and stop the service. 

```puppet
  redis {'default-6379-off':
    ensure => absent,
  }
```


# License Information

This module is licensed under the Apache 2.0 license. Redis is license information is available [here](http://www.redis.io/topics/license)

# Configuration Variables

See init.pp for configuration options. All options available in redis.conf should be available via puppet

