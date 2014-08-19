class rabbitmq::install {

  $package_ensure   = $rabbitmq::version
  $package_name     = $rabbitmq::package_name
  $package_provider = $rabbitmq::package_provider

  # Lucid requires updated erlang packages only
  if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '10.04' {
    include '::rabbitmq::repo::erlang'
  }

  package { 'rabbitmq-server':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
    require  => Exec['pivotal-eula-acceptance'],
    notify   => Class['rabbitmq::service'],
  }

}
