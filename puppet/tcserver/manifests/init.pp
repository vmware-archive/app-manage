## Module: tcserver
##
## Installs tc Server
## 
## 


class tcserver ( $tcserver_version = "2.9.3.RELEASE",
  $tcserver_edition = "developer",
  $tcserver_user = "tcserver",
  $install_path = "/opt/pivotal" 
  ) {
  $module = "tcserver"
  $prefix = "/etc/puppet/modules"
  $p1 = "${prefix}/${module}/files"
  $p2 = "puppet:///modules/${module}"
# Shouldn't need to customize beyond this line
  $basename = "vfabric-tc-server"
  $installer = "${basename}-${tcserver_edition}-${tcserver_version}.tar.gz"
# Location of installed files
  $installed_base = "${install_path}/${basename}-${tcserver_edition}-${tcserver_version}"
# Resource defaults.
# TODO: add user for tcserver
  user { "${tcserver_user}":
        ensure => present,
        shell => "/bin/sh",
  }  
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }
# Resource models.
  file {
    "/var/tmp/${installer}":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
  }
  file {
    "${install_path}":
      ensure => "directory",
      mode   => 750,
      owner => "${tcserver_user}",
      group => "${tcserver_user}"
  }
  exec {
    "unpack-tcserver":
      command => "tar -C ${install_path} -x -z -f /var/tmp/${installer}",
      creates => "${installed_base}",
      require => File["/var/tmp/${installer}"];
  }
  file {
    "${installed_base}":
    ensure => "directory",
    mode => 750,
    owner => "${tcserver_user}",
    group => "${tcserver_user}",
    require => Exec['unpack-tcserver']
  }

}

