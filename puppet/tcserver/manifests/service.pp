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

class tcserver::service (
  $ensure = running,
  $name = undef,
  $cwd = undef,
) {
  service { "tcserver-instance-${name}":
    ensure    => $ensure,
    status    => "ps -p `cat ${cwd}/${name}/logs/tcserver.pid` > /dev/null 2>&1",
    require   => File["${cwd}/${name}"]
  }

}
