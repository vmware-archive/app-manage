# Pivotal Redis Module for Puppet

This README covers the initial release of the Pivotal's Redis module for puppet. This README assumes the reader has a basic understanding of puppet and Redis.

# About this module

This module installs redis from the Pivotal APT Repo (YUM Repo Pending).

# Before you begin

This module depends on the vfabric_repo module

# Example Usage

```puppet
  class {'redis':
    ensure => running,
    listen_port => '9001'
  }

```
# Configuration Variables

See init.pp for configuration options

