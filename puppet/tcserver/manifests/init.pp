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

class tcserver (
  $version = 'latest',
  $tcserver_user = 'tcserver',
  $tcserver_group = 'vfabric',
  $uses_templates = true,
  $templates_source = 'puppet:///modules/tcserver/templates',
  ) {

  $installed_base = '/opt/vmware/vfabric-tc-server-standard'

  class {'tcserver::install':
    version => $version
  } ->

  class {'tcserver::postinstall':
    uses_templates => $uses_templates
  }
}

