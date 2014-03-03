#rabbitmq

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rabbitmq](#setup)
    * [What rabbitmq affects](#what-rabbitmq-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rabbitmq](#beginning-with-rabbitmq)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module manages RabbitMQ (www.rabbitmq.com)

##Module Description
The Pivotal RabbitMQ module is an adaptation of the original puppetlabs-rabbitmq module. This module has been adapted to work
with the commercial RabbitMQ packages provided by Pivotal. 

The rabbitmq module sets up rabbitmq and has a number of providers to manage
everything from vhosts to exchanges after setup.

This module has been tested against 3.2.1 and is known to not support
all features against earlier versions.

##Setup

###What rabbitmq affects

* rabbitmq repository files.
* rabbitmq package.
* rabbitmq configuration file.
* rabbitmq service.

###Beginning with rabbitmq

```puppet

include '::rabbitmq'
```

##Usage

All options and configuration can be done through interacting with the parameters
on the main rabbitmq class.  These are documented below.

##rabbitmq class

To begin with the rabbitmq class controls the installation of rabbitmq.  In here
you can control many parameters relating to the package and service, such as
disabling puppet support of the service:

```puppet
class {'pivotal_repo':
  i_accept_eula => true
}

class { '::rabbitmq':
  service_manage    => false,
  port              => '5672',
}
```

### Environment Variables
To use RabbitMQ Environment Variables, use the parameters `environment_variables` e.g.:

```puppet
class { 'rabbitmq':
  port              => '5672',
  environment_variables   => {
    'RABBITMQ_NODENAME'     => 'node01',
    'RABBITMQ_SERVICENAME'  => 'RabbitMQ'
  }
}
```

### Variables Configurable in rabbitmq.config
To change RabbitMQ Config Variables in rabbitmq.config, use the parameters `config_variables` e.g.:

```puppet
class { 'rabbitmq':
  port              => '5672',
  config_variables   => {
    'hipe_compile'  => true,
    'frame_max'     => 131072,
    'log_levels'    => "[{connection, info}]"
  }
}
```

### Clustering
To use RabbitMQ clustering and H/A facilities, use the rabbitmq::server
parameters `config_cluster`, `cluster_nodes`, and `cluster_node_type`, e.g.:

```puppet
class { 'rabbitmq':
  config_cluster    => true, 
  cluster_nodes     => ['rabbit1', 'rabbit2'],
  cluster_node_type => 'ram',
}
```

**NOTE:** You still need to use `x-ha-policy: all` in your client 
applications for any particular queue to take advantage of H/A.

You should set the 'config_mirrored_queues' parameter if you plan
on using RabbitMQ Mirrored Queues within your cluster:

```puppet
class { 'rabbitmq':
  config_cluster         => true,
  config_mirrored_queues => true,
  cluster_nodes          => ['rabbit1', 'rabbit2'],
}
```

##Native Types

### rabbitmq\_user

query all current users: `$ puppet resource rabbitmq_user`

```
rabbitmq_user { 'dan':
  admin    => true,
  password => 'bar',
}
```

### rabbitmq\_vhost

query all current vhosts: `$ puppet resource rabbitmq_vhost`

```puppet
rabbitmq_vhost { 'myhost':
  ensure => present,
}
```

### rabbitmq\_user\_permissions

```puppet
rabbitmq_user_permissions { 'dan@myhost':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}
```

### rabbitmq\_plugin

query all currently enabled plugins `$ puppet resource rabbitmq_plugin`

```puppet
rabbitmq_plugin {'rabbitmq_stomp':
  ensure => present,
}
```

##Limitations

This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6
* CentOS 5/6
* Ubuntu 12.04
* Ubunut 10.04

Testing on other platforms has been light and cannot be guaranteed.


### Authors
* Wes Schlichter <wschlichter@gopivotal.com>
* Jeff McCune <jeff@puppetlabs.com>
* Dan Bode <dan@puppetlabs.com>
* RPM/RHEL packages by Vincent Janelle <randomfrequency@gmail.com>
* Puppetlabs Module Team
