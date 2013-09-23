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


class tcserver ( $tcserver_version = "2.9.3.RELEASE",   #this is only valid for non-repo based installs
  $tcserver_edition = "developer",
  $tcserver_user = "tcserver",
  $tcserver_group = "vfabric",
  $install_path = "/opt/vmware",
  $uses_templates = true,
  $templates_source = "puppet:///modules/tcserver/templates",
  ) {
# Resource defaults.
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

# The vfabric_repo package installs the vFabric YUM Repo. If it is included then we default to installing via yum.  
  if defined('vfabric_repo') {
    package {'vfabric-tc-server-standard.noarch':
      provider => 'yum',
      ensure => "installed",
      require => [ Package['vfabric-5.3-repo'], Exec['vfabric-eula-acceptance'] ]
    }
    $installed_base = "/opt/vmware/vfabric-tc-server-standard"
    if $uses_templates {
      file { "${tcserver::params::installed_base}/templates":
        group => "${tcserver_group}",
        recurse => true,
        source => "${templates_source}",
        require => Package['vfabric-tc-server-standard.noarch']
      }
    }
    user { "${tcserver_user}":
      groups => "${tcserver_group}",
      require => Package['vfabric-tc-server-standard.noarch']
    }
  } else {
    user { "${tcserver_user}":
      ensure => present,
      shell => "/bin/sh",
    }

    $installed_base = "${install_path}/${basename}-${tcserver_edition}-${tcserver_version}"
    file {
      "/var/tmp/${installer}":
        source  => [ "${tcserver::params::p1}/${tcserver::params::installer}", "${tcserver::params::p2}/${tcserver::params::installer}" ],
    }
    file {
      "${install_path}":
        ensure => "directory",
        owner => "${tcserver_user}",
        group => "${tcserver_group}"
    }
    exec {
      "unpack-tcserver":
        command => "tar -C ${install_path} -x -z -f /var/tmp/${tcserver::params::installer}",
        creates => "${installed_base}",
        require => File["/var/tmp/${tcserver::params::installer}"];
    }
    file {
      "${installed_base}":
      ensure => "directory",
      owner => "${tcserver_user}",
      group => "${tcserver_group}",
      require => Exec['unpack-tcserver']
    }
    if $uses_templates {
      file { "${installed_base}/templates":
        group => "${tcserver_group}",
        recurse => true,
        source => "${templates_source}",
        require => Exec['unpack-tcserver']
      }
    }

  }
}

