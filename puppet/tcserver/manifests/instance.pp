##  tcserver::instance
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
##  Creates an instance on a tc Server installation. 
##
## Variables:
##   $name = Name of the instance to be passed to the tcruntime-instance script
##   $ensure = One of running, stopped, absent
##   $use_java_home = If true it will pass the value of $java_home to tcruntime-instance via --java-home option
##   $java_home = Location of JRE/JDK. 
##   $properties_file = Location of properties file (not supported yet)
##   $layout = Type of instance layout
##   $version = tomcat runtime to use
##   $base_dir = Location to create the instance, defaults to root directory of tc Server

define tcserver::instance (
  $ensure = "running",
  $template = undef,
  $use_java_home = false,
  $java_home = "/usr",
  $properties_file = undef,
  $layout = undef,
  $version = undef,
  $base_dir = undef,
  $user = "${tcserver::tcserver_user}",
  $apps_dir = "webapps",
  $apps_source = "puppet:///modules/tcserver/webapps",
  $deploy_apps = false,
  $base_jmx_port = 6969,
  $bio_http_port = 8080,
  $bio_https_port = 8443
){
  if $template {
    $template_option = "-t ${template}"
  } else {
    $template_option = ""
  }

  if $use_java_home {
    $java_home_option = "--java-home ${java_home}"
  } else {
    $java_home_option = ""
  }

  if $properties_file { 
    $properties_file_option = "--properties-file ${properties-file}"
  } else {
    $properties_file_option = ""
  }

  if $layout {
    $layout_option = "--layout ${layout}"
  } else {
    $layout_option = ""
  }

  if $version {
    $version_option = "--version ${version}"
  } else {
    $version_option = ""
  }
  
  if $base_dir {
    $cwd = $base_dir
  } else {
    $cwd = "${tcserver::installed_base}"
  }

  $properties = "-p bio.http.port=${bio_http_port} -p bio.https.port=${bio_https_ports} -p base.jmx.port=${base_jmx_port}"
  
  if $ensure == "running" or $ensure == "stopped" {
    exec { "create_instance-$name":
      environment => "JAVA_HOME=${java_home}",
      cwd => "${cwd}",
      command => "${tcserver::installed_base}/tcruntime-instance.sh create ${name} ${template_option} ${java_home_option} ${properties} ${properties_file_option} ${layout_option} ${version_option}",
      creates => "${cwd}/${name}",
    }

    file { "${cwd}/${name}":
      ensure => directory,
      owner => $user,
      recurse => true,
      ignore => "${cwd}/${name}/${apps_dir}",
      require => Exec["create_instance-${name}"]
    }

    file { "/etc/init.d/tcserver-instance-${name}":
      target => "${cwd}/${name}/bin/init.d.sh",
      ensure => link
    }

    service { "tcserver-instance-${name}":
      name => "tcserver-instance-${name}",
      ensure => $ensure,
      status => "ps -p `cat ${cwd}/${name}/logs/tcserver.pid` > /dev/null 2>&1",
      require => File["${cwd}/${name}"]
    } 

    if $deploy_apps {
      file { "${cwd}/${name}/${apps_dir}":
        recurse => true,
        source => "${apps_source}"
      }
    }
  } else {
    service { "tcserver-instance-${name}":
      name => "tcserver-instance-${name}",
      ensure => stopped,
      status => "ps -p `cat ${cwd}/${name}/logs/tcserver.pid` > /dev/null 2>&1",
      before => File["${cwd}/${name}"]
    }

    file { "${cwd}/$name":
      ensure => "absent",
      force => true
    }

    file { "/etc/init.d/tcserver-instance-${name}":
      require => File["${cwd}/$name"],
      ensure => "absent"
    }
  }
}
