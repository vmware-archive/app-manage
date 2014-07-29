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

class tcserver::postinstall (
  $ensure = present,
  $uses_templates = true,
) {
  if $uses_templates {
    if $ensure == absent {
      file { "${::tcserver::installed_base}/templates":
        ensure => $ensure,
        force  => true,
      }
    } else {
      file { "${::tcserver::installed_base}/templates":
        recurse => true,
		force => true,
        source  => $::tcserver::templates_source,
        require => Class['::tcserver::install']
      }
    }
  }

  # set permissions of all files to user/group passed in
  exec { 'setting permissions':
    command => "/bin/chown -R ${::tcserver::tcserver_user}:${::tcserver::tcserver_group} ${::tcserver::installed_base}",
  }

  user { $::tcserver::tcserver_user:
    groups  => $::tcserver::tcserver_group,
    require => Class['::tcserver::install']
  }
}
