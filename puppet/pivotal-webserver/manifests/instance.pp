## Pivotal Web Server Puppet Module
##
## Copyright 2013-2014 Pivotal Software, Inc
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
##
## Configuration Information
##
##  $ensure
##    Default - running
##    The default state of the instance. Valid options are running, absent, stopped
##
## The remainder of thevariables below correspond to webserver "newserver"
## command options. Please see the appropriate documentation for details

define webserver::instance (
  $ensure = 'running',
  $admin_email = undef,
  $sslport = undef,
  $user = undef,
  $group = undef,
  $port = undef,
  $hostname = undef,
  $base_dir = undef,
  $overlay = undef,
  $serverdir = undef,
  $mpm = undef,
  $httpdver = undef,
  $sourcedir = undef,

){
  require webserver

  if $admin_email {
    $set_admin_email = "--set ServerAdmin=${admin_email}"
  }

  if $sslport {
    $set_ssl_port = "--set SSLPort=${sslport}"
  }

  if $user {
    $set_user = "--set User=${user}"
  }

  if $group {
    $set_group = "--set Group=${group}"
  }

  if $port {
    $set_port = "--set Port=${port}"
  }

  if $hostname {
    $set_hostname = "--set Hostname=${hostname}"
  }

  $set = "${set_admin_email} ${set_ssl_port} ${set_user} ${set_group} ${set_port} ${set_hostname}"

  if $overlay and $overlay == true {
    $options_overlay = '--overlay '
  }

  if $serverdir {
    $options_serverdir = "${options} --serverdir=${serverdir} "
  }

  if $mpm {
    $options_mpm = "${options} --mpm=${mpm} "
  }

  if $httpdver {
    $options_httpdver = "${options} --httpdver=${httpdver} "
  }

  if $sourcedir {
    $options_sourcedir = "${options} --sourcedir=${sourcedir} "
  }

  $options = "${options_overlay} ${options_serverdir} ${options_mpm} ${options_httpdver} ${options_sourcedir}"

  $cwd = $::webserver::installed_base

  if $ensure == running or $ensure == stopped {
    exec { "create_instance-${name}":
      cwd     => $cwd,
      command => "${webserver::installed_base}/newserver --quiet ${name} ${options} ${set}",
      creates => "${cwd}/${name}",
      require => File[$::webserver::installed_base]
    }

    file { "/etc/init.d/pivotal-httpd-${name}":
      ensure  => link,
      source  => "${cwd}/${name}/bin/httpdctl",
      require => Exec["create_instance-${name}"],
    }

    service { "webserver-instance-${name}":
      ensure  => $ensure,
      name    => "pivotal-httpd-${name}",
      status  => "ps -p `cat ${cwd}/${name}/logs/httpd.pid` > /dev/null 2>&1",
      require => File["/etc/init.d/pivotal-httpd-${name}"]
    }
  } else {
    service { "webserver-instance-${name}":
      ensure  => stopped,
      name    => "webserver-instance-${name}",
      status  => "ps -p `cat ${cwd}/${name}/logs/webserver.pid` > /dev/null 2>&1",
      before  => File["${cwd}/${name}"]
    }->
    file { "${cwd}/${name}":
      ensure  => absent,
      force   => true
    }->
    file { "/etc/init.d/webserver-instance-${name}":
      ensure  => absent,
      require => File["${cwd}/${name}"],
    }
  }
}
