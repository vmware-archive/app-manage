## Pivotal Web Server Puppet Module
##
## Copyright 2013 Pivotal Software, Inc
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

  if $ensure != present or $ensure != running {
    $file_ensure = present
    $link_ensure = link
  } else {
    $file_ensure = absent
    $link_ensure = absent
  }

  if $ensure == absent or $ensure == present {
    $service_ensure = stopped
  } else {
    $service_ensure = $ensure
  }

  case $::osfamily {
    'Debian': {
      file {"/etc/init.d/redis-${port}":
        ensure  => $link_ensure,
        target  => '/lib/init/upstart-job'
      } ->
      file {"/etc/init/redis-${port}.conf":
        ensure  => $file_ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template("redis/redis.upstart-${::operatingsystemrelease}.erb"),
      } ->
      service { "redis-${port}":
        ensure  => $service_ensure,
        status  => "/usr/sbin/service redis-${port} status| grep start",
        require => Package['pivotal-redis']
      }
    }
    'RedHat': {
      file {"/etc/init.d/pivotal-redis-${port}":
        ensure  => $file_ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0555',
        content => template('redis/pivotal-redis.erb')
      } ->
      service { "redis-${port}":
        ensure  => $service_ensure,
        name    => "pivotal-redis-${port}",
        require => Package['pivotal-redis']
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
