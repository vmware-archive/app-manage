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
##
## Configuration Information
##
##  $version
##    Default - latest
##    Specifies the version of the package to be installed. A value of
##    latest will use the latest version available in the package
##    repository
##
##  $uses_templates
##    Default - false
##    Specifies whether this installation should use templates. If true
##    then the contents of $template_source will be copied to the installation's
##    templates directory
##
##  $templates_dir
##    Default - 'templates'
##    The location of the templates directory on the vfws installation. Normally
##    this value would never need to be changed.
##
##  $templates_source
##    Default - 'puppet:///modules/vfws/templates'
##    Specifies the location to find the template files to copy from. This should be
##    a valid puppet url.

class vfws (
  $version = latest,
  $uses_templates = false,
  $templates_dir = 'templates',
  $templates_source = 'puppet:///modules/vfws/templates'  #Location to copy templates from
  ) {

  $installed_base = '/opt/vmware/vfabric-web-server'

  if defined('pivotal_repo') {
    package {'vfabric-web-server':
      ensure   => $version,
      require  => Exec['vfabric-eula-acceptance'],
    }
    if $uses_templates {
      file { "${installed_base}/${templates_dir}":
        recurse => true,
        source  => $templates_source,
        require => Package['vfabric-web-server']
      }
    }
    file { $installed_base:
      require => Package['vfabric-web-server']  #this just gives us something to require from the instance
    }
  } else {
    fail 'pivotal_repo module missing'
  }
}
