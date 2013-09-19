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
  $module = "tcserver"
  $prefix = "/etc/puppet/modules"
  $p1 = "${prefix}/${module}/files"
  $p2 = "puppet:///modules/${module}"
# Shouldn't need to customize beyond this line
  $basename = "vfabric-tc-server"
  $installer = "${basename}-${tcserver_edition}-${tcserver_version}.tar.gz"
# Resource defaults.
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

# The vfabric_repo package installs the vFabric YUM Repo. If it is included then we default to installing via yum.  
  if defined('vfabric_repo') {
    package {'vfabric-tc-server-standard.noarch':
      provider => 'yum',
      ensure => "installed",
      require => [ Package['vfabric-5-repo'], Exec['vfabric-eula-acceptance'] ]
    }
    $installed_base = "/opt/vmware/vfabric-tc-server-standard"
    if $uses_templates {
      file { "${installed_base}/templates":
        group => "${tcserver_group}",
        recurse => true,
        source => "${templates_source}",
        require => Package['vfabric-tc-server-standard.noarch']
      }
    }
  } else {
    user { "${tcserver_user}":
        ensure => present,
        shell => "/bin/sh",
    }

    $installed_base = "${install_path}/${basename}-${tcserver_edition}-${tcserver_version}"
    file {
      "/var/tmp/${installer}":
        source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
    }
    file {
      "${install_path}":
        ensure => "directory",
        owner => "${tcserver_user}",
        group => "${tcserver_group}"
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

