## 


class vfws ( $vfws_version = "5.3.1-2-x86_64-linux-glibc2",
  $vfws_user = "vfws",
  $install_path = "/opt/pivotal" 
  ) {
  $module = "vfws"
  $prefix = "/etc/puppet/modules"
  $p1 = "${prefix}/${module}/files"
  $p2 = "puppet:///modules/${module}"
# Shouldn't need to customize beyond this line
  $basename = "vfabric-web-server"
  $installer = "${basename}-${vfws_version}.zip.sfx"
  $installed_base = "${install_path}/${basename}"
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

# Resource models.
  file {
    "/var/tmp/${installer}":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
  }
  file { "${install_path}":
      ensure => "directory",
      mode   => 750,
  }
  exec { "unpack-vfws":
      cwd => "${install_path}",
      command => "/var/tmp/${installer}",
      creates => "${installed_base}",
      require => File["/var/tmp/${installer}"];
  }
  file { "${installed_base}":
    ensure => "directory",
    require => Exec['unpack-vfws']
  }

}

