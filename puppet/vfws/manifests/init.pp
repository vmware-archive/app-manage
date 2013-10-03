## vFabric Web Server Puppet Module
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
## See README for configuration details

class vfws (
  $version = latest,
  $uses_templates = false,
  $templates_dir = 'templates',
  $templates_source = 'puppet:///modules/vfws/templates'  #Location to copy templates from
  ) {

  $installed_base = '/opt/vmware/vfabric-web-server'

  if defined('vfabric_repo') {
    package {'vfabric-web-server':
      ensure   => $version,
      require  => Exec['vfabric-eula-acceptance'],
    }
    if $uses_templates {
      file { "${installed_base}/${templates_dir}":
        recurse => true,
        source  => $templates_source,
        require => Package['vfabric-web-server']
      }
    }
    file { $installed_base:
      require => Package['vfabric-web-server']  #this just gives us something to require from the instance
    }
  } else {
    fail 'vfabric_repo module missing'
  }
}
