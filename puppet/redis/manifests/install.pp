

class redis::install ( $version = "latest" ) {
  
  package {'redis':
    ensure => $version
  }

}
