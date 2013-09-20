##  vfws::instance
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
##  Creates an instance on a vfws installation. 
##
## Variables:
##   $name = Name of the instance to be passed to the newserver script
##   $ensure = One of running, stopped, absent

define vfws::instance (
  $ensure = "running",
  $admin_email = undef,
  $sslport = undef,
  $user = undef,
  $group = undef,
  $port = undef,
  $hostname = undef,  
#  $version = undef,
  $base_dir = undef,
  $overlay = undef,
  $serverdir = undef,
  $mpm = undef,
  $httpdver = undef,
  $sourcedir = undef,

){
 
  if $admin_email {
    $set_admin_email = "--set AdminEmail={$admin_email} "
  }

  if $sslport {
    $set_port = "--set SSLPort=${sslport} "
  }

  if $user {
    $set_user = "--set User=${user} "
  }

  if $group {
    $set_group = "--set Group=${group} "
  }

  if $port {
    $set_port = "--set Port=${port} "
  }

  if $hostname {
    $set_hostname += "--set Hostname=${hostname}"
  }

  $set = "${set_admin_email} ${set_ssl_port} ${set_user} ${set_group} ${set_port} ${set_hostname}"

  if $overlay and $overlay == "true" {
    $options_overlay = "--overlay "
  }

  if $serverdir {
    $options_serverdir = "${options} --serverdir=${serverdir} "
  }

  if $mpm {
    $options_mpm = "${options} --mpm=${mpm} "
  }

  if $httpdver {
    $options_httpdver = "${options} --httpdver=${httpdver} "
  }

  if $sourcedir {
    $options_sourcedir = "${options} --sourcedir=${sourcedir} "
  }

  $options = "${options_overlay} ${options_serverdir} ${options_mpm} ${options_httpdver} ${options_source_dir}"

  $cwd = "${vfws::installed_base}"

  if $ensure == "running" or $ensure == "stopped" {
    exec { "create_instance-${name}":
      cwd => "${cwd}",
      command => "${vfws::installed_base}/newserver --quiet ${name} ${options} ${set}",
      creates => "${cwd}/${name}",
      require => File["${vfws::installed_base}"]
    }

    exec { "install_instance-${name}":
      cwd => "${cwd}/${name}",
      command => "${cwd}/${name}/bin/httpdctl install",
      require => Exec["create_instance-${name}"],
      creates => "/etc/init.d/vFabric-httpd-$name"
    }

    service { "vfws-instance-${name}":
      name => "vFabric-httpd-${name}",
      ensure => $ensure,
      status => "ps -p `cat ${cwd}/${name}/logs/httpd.pid` > /dev/null 2>&1",
      require => Exec["install_instance-${name}"]
    } 


  } else {
    service { "vfws-instance-${name}":
      name => "vfws-instance-${name}",
      ensure => stopped,
      status => "ps -p `cat ${cwd}/${name}/logs/vfws.pid` > /dev/null 2>&1",
      before => File["${cwd}/${name}"]
    }

    file { "${cwd}/$name":
      ensure => "absent",
      force => true
    }

    file { "/etc/init.d/vfws-instance-${name}":
      require => File["${cwd}/$name"],
      ensure => "absent"
    }
  }
}
