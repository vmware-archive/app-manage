# requires
#   puppetlabs-apt
#   puppetlabs-stdlib
class rabbitmq::repo::erlang {

  Class['rabbitmq::repo::erlang'] -> Package<| title == 'rabbitmq-server' |>

  apt::source { 'erlang-solutions':
    location    => 'http://packages.erlang-solutions.com/debian',
    release     => 'lucid',
    repos       => 'contrib',
    include_src => false,
    key         => 'D208507CA14F4FCA',
    key_source  => 'http://packages.erlang-solutions.com/debian/erlang_solutions.asc'
  }->
  package {'esl-erlang':
    ensure      => present,
    before      => Package['rabbitmq-server']
  }
}
