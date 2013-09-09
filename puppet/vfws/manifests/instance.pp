##  vfws::instance
##  
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
  $version = undef,
  $base_dir = undef,
){
  
  if $admin_email {
    $set += "--set AdminEmail={$admin_email} "
  }

  if $sslport {
    $set += "--set SSLPort=${sslport} "
  }

  if $user {
    $set += "--set User=${user} "
  }

  if $group {
    $set += "--set Group=${group} "
  }

  if $port {
    $set += "--set Port=${port} "
  }

  if $hostname {
    $set += "--set Hostname=${hostname}"
  }

  $cwd = "${vfws::installed_base}"

  if $ensure == "running" or $ensure == "stopped" {
    exec { "create_instance-${name}":
      cwd => "${cwd}",
      command => "${vfws::installed_base}/newserver --quiet ${name} ${set}",
      creates => "${cwd}/${name}"
    }

    exec { "install_instance-${name}":
      cwd => "${cwd}/${name}",
      command => "${cwd}/${name}/bin/httpdctl install",
      require => Exec["create_instance-${name}"]
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
