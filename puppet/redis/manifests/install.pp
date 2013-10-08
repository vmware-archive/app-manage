## Class redis::install
#
# See manifests/init.pp for variable definitions

class redis::install ( $version = 'latest' ) {
  package {'redis':
    ensure => $version
  }
}
