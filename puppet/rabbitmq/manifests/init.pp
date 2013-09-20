## RabbitMQ Puppet Module
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
## See README for configuration details

class rabbitmq (
  # Valid: running, stopped, absent 
  $ensure = "running"
) {
  $installed_base = "/opt/vmware/rabbitmq"

  if defined('vfabric_repo') {
    if $ensure == "running" or $ensure == "stopped" {
      package {'vfabric-rabbitmq-server':
        provider => 'yum',
        ensure => "installed",
        require => [ Package['vfabric-5.3-repo'], Exec['vfabric-eula-acceptance'] ],
      }

      service {'rabbitmq-server':
        ensure => $ensure,
        require => Package['vfabric-rabbitmq-server']
      }

      file { "${installed_base}":
        require => Package['vfabric-rabbitmq-server']  #this just gives us something to require from the instance
      }
    } 
    if $ensure == "absent" {
      package {'vfabric-rabbitmq-server':
        provider => 'yum',
        ensure => "uninstalled",
      }
    }
  } else {
    alert "[$fqdn] This module depends on vfabric_repo module"
  }
}
