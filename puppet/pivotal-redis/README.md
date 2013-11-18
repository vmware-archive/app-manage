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

The following will install Pivotal Redis with a master-slave replication config on the same node and include authentication
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

# License Information

This module is licensed under the Apache 2.0 license. Redis is license information is available [here](http://www.redis.io/topics/license)

# Configuration Variables

See init.pp for configuration options. All options available in redis.conf should be available via puppet

