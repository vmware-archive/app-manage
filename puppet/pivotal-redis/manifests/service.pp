## vFabric Web Server Puppet Module
##
## Copyright 2013 GoPivotal, Inc
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

define redis::service (
  $ensure = running,
  $owner = 'redis',
  $group = 'pivotal',
  $port = 6379) {


  case $::osfamily {
    'Debian': {
      file {"/etc/init.d/redis-${port}":
        ensure  => link,
        target  => '/lib/init/upstart-job'
      } ->
      file {"/etc/init/redis-${port}.conf":
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template("redis/redis.upstart-${::operatingsystemrelease}.erb"),
      } ->
      service { "redis-${port}":
        ensure  => $ensure,
        status  => "/usr/sbin/service redis-${port} status| grep start",
        require => Package['pivotal-redis']
      }
    }
    'RedHat': {
      file {"/etc/init.d/pivotal-redis-${port}":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0555',
        content => template('redis/pivotal-redis.erb')
      } ->
      service { "redis-${port}":
        name    => "pivotal-redis-${port}",
        ensure  => $ensure,
#        status  => "/usr/sbin/service redis-${port} status| grep start",
        require => Package['pivotal-redis']
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
