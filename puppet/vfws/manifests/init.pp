## vFabric Web Server Puppet Module
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this module require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
## See README for configuration details

class vfws ( $vfws_version = "5.3.1-2-x86_64-linux-glibc2",
  $vfws_user = "vfws",
  $install_path = "/opt/vmware",
  $uses_templates = false,
  $template_dir = "templates",
  $templates_source = "puppet:///modules/vfws/templates"  #Location to copy templates from
  ) {

  $module = "vfws"
  $installed_base = "${install_path}/${basename}"
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

  if defined('vfabric_repo') {
    package {'vfabric-web-server':
      provider => 'yum',
      ensure => "installed",
      require => [ Package['vfabric-5.3-repo'], Exec['vfabric-eula-acceptance'] ],
    }
    if $uses_templates {
      file { "${installed_base}/${templates_dir}":
        recurse => true,
        source => "${templates_source}",
        require => Package['vfabric-web-server']
      }
    }
    file { "${installed_base}":
      require => Package['vfabric-web-server']  #this just gives us something to require from the instance
    }
  } else {
    fail "vfabric_repo module missing"
  }
}
