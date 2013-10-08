## Class redis::service
#
# See manifests/init.pp for variable definitions

class redis::service ( $ensure = running) {
  service { 'redis':
    ensure  => $ensure,
    require => Package['redis']
  }
}
