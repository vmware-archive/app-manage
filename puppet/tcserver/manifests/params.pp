class tcserver::params {

  $module = "tcserver"
  $prefix = "/etc/puppet/modules"
  $p1 = "${prefix}/${module}/files"
  $p2 = "puppet:///modules/${module}"
  $basename = "vfabric-tc-server"
  $installer = "${basename}-${tcserver_edition}-${tcserver_version}.tar.gz"


}