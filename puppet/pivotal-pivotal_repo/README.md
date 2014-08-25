# Pivotal Package Repository Module for Puppet

This README covers the initial release of the Pivotal Package Repository module for puppet. This README assumes the reader has a basic understanding of puppet and Pivotal Package Repository.

# About this module

This module will install Pivotal Package Repository to the target node(s). Use of this module requires acceptance of the End User License Agreement(EULA) located at http://www.vmware.com/download/eula/fabric_app-platform_eula.html

All other Pivotal modules depend on this module for product installation. 

# Before you begin 

Currently only RHEL 5/6 and Ubuntu 10.04/12.04 are supported. 

This module requires the following modules.

  * maestrodev/wget
  * puppetlabs/apt

# Usage

```puppet

  class {'pivotal_repo':
    i_accept_eula => true
  }
```
# License Information

This module is licensed under the Apache 2.0 license

# Configuration Information

Please see manifests/init.pp for configuration options
