# Pivotal vFabric Package Repository Module for Puppet

This README covers the initial release of the vFabric Package Repository module for puppet. This README assumes the reader has a basic understanding of puppet and vFabric Package Repository.

# About this module

This module will install vFabric Package Repository to the target node(s). Use of this module requires acceptance of the End User License Agreement(EULA) located at http://www.vmware.com/download/eula/vfabric_app-platform_eula.html

This module should be used with other vFabric modules to prefer repository packages over .tar.gz/sfx packages.

# Prerequisites 

This module requires the following modules

  * maestrodev/wget
  * puppetlabs/apt


# Usage

```puppet

  class {'vfabric_repo':
    i_accept_eula => true
  }


```

# Configuration Variables

##vFabric Package Repository Base

**i_accept_eula** - This option must be set to true and requires acceptance of the End User License Agreement

