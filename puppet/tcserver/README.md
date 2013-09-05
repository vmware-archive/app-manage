# Pivotal tc Server Module for Puppet

This README covers the initial release of the tc Server module for puppet. This README assumes the reader has a basic understanding of puppet and tc Server.

# Basics of this module

This module will install tc Server to the target node(s). It requires that a copy of the installation media be located on the puppet master. 

# Example Usage

*Basic usage* - The following example will install tc Server and create an instance called myinstance using all the defaults

```puppet
node 'default' {
  include tcserver    # Include the base tcserver class. This will automatically install tc Server using the defaults

  tcserver::instance {"myinstance":
  }

}
```


*Advanced usage* - Multiple instances and specified version of tc Server.

```puppet
node 'default' {

  class {'tcserver':
    tcserver_version => "2.9.2.RELEASE"
  }

  tcserver::instance {"default_properties":
  }

  tcserver::instance {"special_ports":
    bio_http_port => 8081,
    bio_https_port => 8444,
    base_jmx_port => 6970,
    deploy_apps => true,
    ensure => running
  }

}
```

# Configuration Variables

*tc Server Base*

The base class of tcserver supports the following configuration variables

*tcserver_version* - Specifies the version of tc Server to use. This must match the installation media placed in puppet:///modules/tcserver/files. _Default_: 2.9.3.RELEASE
*tcserver_edition* - Specifies the edition of tc Server to use(standard, developer). This must match the installation media placed in puppet:///modules/tcserver/files. _Default_:developer
*tcserver_user* - The user to create on the system to run tc Server instances and own files. _Default_: tcserver
*install_path* - The location to install the tc Server base. _Default_: /opt/pivotal

*tc Server Instance*

The resource type for creating instances.

*ensure* - State of tc Server instance. Valid values are "running", "stopped", "absent". _Default_: "running"
*template* - The value to pass to the "-t" option of tcruntime-instance. _Default_: no value
*use_java_home* - Wether to specify the value of $java_home as an argument to tcruntime-instance. _Default_: false
*java_home* - The value of JAVA_HOME defined prior to running tcruntime-instance. Useful on systems with unmanaged JAVA_HOME env variables  _Default_: no value
*properties_file* - The value to pass to the "--properties-file" option of tcruntime-instance. _Default_:no value
*layout* - The value to pass to the --layout option of tcruntime-instance. _Default_: no value
*version* - The value to pass to the --version option of tcruntime-instance. This controls the version of tomcat used not the version of tc Server. _Default_: no value
*base_dir* - The directory in which to create the instance of tc Server. _Default_: tc Server install_path variable
*apps_dir* - The directory to use to deploy webapps to. This will be unmanaged by puppet unless $deploy_apps is true. _Default_: "webapps"
*apps_source* - The location to find the webapps for deployment. _Default_: "puppet:///modules/tcserver/webapps"
*deploy_apps* - Whether puppet should deploy the contents of $apps_sources to $apps_dir and manage them. _Default_: false
*base_jmx_port* - This defines the value of the base.jmx.port property used by the instance. _Default_: 6969
*bio_http_port* - This defines the value of the bio.http.port property used by the instance. _Default_: 8080
*bio_https_port* - This defines the value of the bio.https.ports property used by the instance. _Default_: 8443

