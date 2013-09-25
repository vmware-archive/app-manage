##  vfws::params
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html

class vfws::params {
  $module = "vfws"
  $prefix = "/etc/puppet/modules"
  $p1 = "${prefix}/${module}/files"
  $p2 = "puppet:///modules/${module}"
  $basename = "vfabric-web-server"
  $installer = "${basename}-${vfws_version}.zip.sfx"
  $installed_base = "${install_path}/${basename}"
}