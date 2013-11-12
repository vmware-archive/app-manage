# Pivotal Redis Module for Puppet

This README covers the initial release of the Pivotal's Redis module for puppet. This README assumes the reader has a basic understanding of puppet and Redis.

# About this module

This module installs redis from the Pivotal APT Repo (YUM Repo Pending). For RHEL/Yum usage you will need to add a separate repository prior to invoking this module.

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

# License Information

This module is licensed under the Apache 2.0 license

# Configuration Variables

See init.pp for configuration options. All options available in redis.conf should be available via puppet

