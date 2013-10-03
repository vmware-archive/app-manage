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

class tcserver::postinstall (
  $uses_templates = true,
) {
  if $uses_templates {
    file { "${::tcserver::installed_base}/templates":
      group   => $::tcserver::tcserver_group,
      recurse => true,
      source  => $::tcserver::templates_source,
      require => Package['vfabric-tc-server-standard.noarch']
    }
  }
  user { $::tcserver::tcserver_user:
    groups  => $::tcserver::tcserver_group,
    require => Package['vfabric-tc-server-standard.noarch']
  }
}
