class rabbitmq::install {

  $package_ensure   = $rabbitmq::version
  $package_name     = $rabbitmq::package_name
  $package_provider = $rabbitmq::package_provider

  package { 'rabbitmq-server':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
    require  => Exec['vfabric-eula-acceptance'],
    notify   => Class['rabbitmq::service'],
  }

}
