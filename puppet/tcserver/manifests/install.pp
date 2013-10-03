## Module: tcserver
##
## Installs tc Server
##
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##

class tcserver::install(
  $version = 'latest'
) {

  if defined('vfabric_repo') {
    package {'vfabric-tc-server-standard':
      ensure    => $version,
      require   => Exec['vfabric-eula-acceptance']
    }
  } else {
    fail 'vfabric_repo module not included'
  }
}
