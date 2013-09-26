

class redis::service ( $ensure = running) {
  service { 'redis':
    ensure => $ensure,
    require => Package['redis']
  }
}
