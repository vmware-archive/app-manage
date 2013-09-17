## vfabric_repo module
##
## LEGAL NOTICE
##
## Use of this module and packages installed via this repo require
## acceptace of of the VMWare End User License Agreement located at
## http://www.vmware.com/download/eula/vfabric_app-platform_eula.html
##
## to accept the EULA the variable "i_accept_eula" must be set to true
## 
##


class vfabric_repo ( 
  $all = "false",
  $ensure = "installed",
  $i_accept_eula = false
  ) {
  
  $vfabric5_repo_url = "http://repo.vmware.com/pub/rhel5/vfabric/5/vfabric-5-repo-5-2.noarch.rpm"
  $vfabric_all_repo_url = "http://repo.vmware.com/pub/rhel5/vfabric-all/vfabric-all-repo-1-1.noarch.rpm"
  
  if $osfamily == "RedHat" and $i_accept_eula == true{
    package { 'vfabric-5-repo':
      provider => 'rpm',
      ensure => $ensure,
      source => $vfabric5_repo_url,
      require => File['/etc/vmware/vfabric/accept-vfabric-eula.txt']
    }

    if $all == "true" {
      package { 'vfabric-all-repo':
        provider => 'rpm',
        ensure => $ensure,
        source => $vfabric_all_url
      }
    }
    
    file {"/etc/vmware/vfabric/accept-vfabric-eula.txt":
      content => "I_ACCEPT_EULA_LOCATED_AT=http://www.vmware.com/download/eula/vfabric_app-platform_eula.html",
      ensure => present,
    }

    file {"/etc/vmware":
      ensure => directory
    }

    file {"/etc/vmware/vfabric":
      ensure => directory,
      require => File['/etc/vmware']
    }
                                  
  } else {
      alert "[${fqdn}] You must accept the terms of the EULA located at http://www.vmware.com/download/eula/vfabric_app-platform_eula.html"
  }
}

