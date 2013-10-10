# Pivotal Redis Module for Puppet

This README covers the initial release of the Pivotal's Redis module for puppet. This README assumes the reader has a basic understanding of puppet and Redis.

# About this module

This module installs redis from the Pivotal APT Repo (YUM Repo Pending). For RHEL/Yum usage you will need to add a separate repository prior to invoking this module.

# Before you begin

This module depends on the vfabric_repo module

# Example Usage

The following example will install redis (see above for repository information with RHEL), configure it to listen on port 9001, and keep the service running. 

```puppet
  class {'redis':
    ensure => running,
    listen_port => '9001'
  }

```

# License Information

This module is licensed under the Apache 2.0 license

# Configuration Variables

See init.pp for configuration options

