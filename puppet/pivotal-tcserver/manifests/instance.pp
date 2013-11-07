## Web Server Puppet Module
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
##
## Requirements
##   This module requires a working java installation
##
## Configuration Information
##
##  $ensure
##    Default - running
##    Specify the state for the instance. Valid values are
##    running, stopped, absent.
##
##  $java_home
##    Default - JAVA_HOME environment variable
##    The value of JAVA_HOME which should be set for the instance.
##
##  $user_java_home
##    Default - true
##    Whether to use the --java-home argument to create the instance
##    If this is false then the instance will be expected to find
##    $JAVA_HOME environment variable to run
##
##  $apps_dir
##    Default - 'webapps'
##    The location on the instance to copy files from $apps_source
##
##  $apps_source
##    Default - 'puppet:///modules/tcserver/webapps'
##    The url to copy webapps from. This must be a valid puppet url
##
##  The remainder of the variables correspond to a tc server property
##  underscores(_) are used in place of hyphens(-)
##
## Ports are not checked for availability. If a port is specified and it is
## in use already the instance will fail to start and puppet will report
## a generic error starting the instance.

define tcserver::instance (
  $ensure = running,
  $template = undef,
  $use_java_home = true,
  $java_home = undef,
  $properties_file = undef,
  $layout = undef,
  $version = undef,
  $base_dir = undef,
  $user = undef,
  $group = undef,
  $apps_dir = 'webapps',
  $apps_source = 'puppet:///modules/tcserver/webapps',
  $deploy_apps = false,
  $base_jmx_port = 6969,
  $bio_http_port = 8080,
  $bio_https_port = 8443
){
  require tcserver

  if !$java_home {
    if $env_java_home {
      $my_java_home = $env_java_home
    } else {
      fail "Please set the configuration variable java_home for this instance."
    }
  } else {
    $my_java_home = $java_home
  }

  if !$user {
    $tcserver_user = $::tcserver::tcserver_user
  } else {
    $tcserver_user = $user
  }

  if !$group {
    $tcserver_group = $::tcserver::tcserver_group
  } else {
    $tcserver_group = $group
  }

  if $template {
    $template_option = "-t ${template}"
  } else {
    $template_option = ''
  }

  if $use_java_home {
    $java_home_option = "--java-home ${my_java_home}"
  } else {
    $java_home_option = ''
  }

  if $properties_file {
    $properties_file_option = "--properties-file ${properties_file}"
  } else {
    $properties_file_option = ''
  }

  if $layout {
    $layout_option = "--layout ${layout}"
  } else {
    $layout_option = ''
  }

  if $version {
    $version_option = "--version ${version}"
  } else {
    $version_option = ''
  }

  if $base_dir {
    $cwd = $base_dir
  } else {
    $cwd = $::tcserver::installed_base
  }

  $properties = "-p bio.http.port=${bio_http_port} -p bio.https.port=${bio_https_port} -p base.jmx.port=${base_jmx_port}"

  if $ensure == 'running' or $ensure == 'stopped' {
    exec { "create_instance-${name}":
      environment => "JAVA_HOME=${my_java_home}",
      cwd         => $cwd,
      command     => "${::tcserver::installed_base}/tcruntime-instance.sh create ${name} ${template_option} ${java_home_option} ${properties} ${properties_file_option} ${layout_option} ${version_option}",
      creates     => "${cwd}/${name}",
      require     => Package['vfabric-tc-server-standard']
    }

    file { "${cwd}/${name}":
      ensure      => directory,
      owner       => $tcserver_user,
      group       => $tcserver_group,
      recurse     => true,
      ignore      => "${cwd}/${name}/${apps_dir}",
      require     => Exec["create_instance-${name}"]
    }

    file { "/etc/init.d/tcserver-instance-${name}":
      ensure      => link,
      target      => "${cwd}/${name}/bin/init.d.sh",
    }

    tcserver::service {$name:
      ensure      => $ensure,
      name        => $name,
      cwd         => $cwd,
    }

    if $deploy_apps {
      file { "${cwd}/${name}/${apps_dir}":
        recurse   => true,
        source    => $apps_source
      }
    }
  } else {
    tcserver::service {$name:
      ensure      => absent,
      name        => $name,
      cwd         => $cwd,
    }

    file { "${cwd}/${name}":
      ensure      => absent,
      force       => true
    }

    file { "/etc/init.d/tcserver-instance-${name}":
      ensure      => absent,
      require     => File["${cwd}/${name}"],
    }
  }
}
