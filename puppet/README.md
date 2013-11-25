# Pivotal/vFabric Puppet Modules

These modules are provided to simplify the installation of vFabric/Pivotal products.  They may be used together or separately. Tested with puppet 3.x.

# Before you begin

 * These modules are only supported for RHEL 5/6 and Ubuntu 10.04/12.04.
 * Some modules depend on other modules from puppet forge please see READMEs for each module for requirements 

# Installation 

**TODO: insert verbage about puppet forge**

## Manual Installation

In the event that manual installation is preferred, the modules will need to be manually copied to your puppet master and renamed to remove the "pivotal-" from each folder. The below is an example of
installation steps on Linux with the community version of puppet installed in /etc/puppet

```
cd /etc/puppet/
git clone https://github.com/pivotal/app-manage.git
cd /etc/puppet/modules
ln -s ../app-manage/puppet/pivotal-pivotal_repo pivotal_repo
ln -s ../app-manage/puppet/pivotal-redis redis
ln -s ../app-manage/puppet/pivotal-tcserver tcserver
ln -s ../app-manage/puppet/pivotal-rabbitmq rabbitmq

# Install puppet module deps
puppet module install puppetlabs/apt
puppet module install maestrodev/wget
puppet module install garethr/erlang
puppet module install puppetlabs/stdlib

```

# Example site.pp

The following example shows basic usage and includes all modules

```puppet
node 'default' {
  
# This is required by add modules
  class {'pivotal_repo':
    i_accept_eula => true
  }

# Create a tc Server instance named 'mySiteWebApps' and customize the http port and https ports
  tcserver::instance {"mySiteWebApps":
    properties  => [['bio.https.port' => '8444'], ['bio.http.port' => '8081']],
    java_home   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
  }

# Create a vFabric Web Server Instance named 'mySite' listening on port 8093
  vfws::instance { "mySite":
    port => '8093',
  }

# Install rabbitmq, manage the service, set it to listen on 5672, and delete the guest user
  class { '::rabbitmq':
    service_manage    => true,
    port              => '5672',
    delete_guest_user => true,
  }

# Create a redis slave instance listening on port 9003
  redis {'9003':
    listen_port => '9003',
    masterauth  => 'mySecurePassword',
    slaveof     => '127.0.0.1 9002'
  }

# Create a redis master listening on port 9002
  redis {'9002':
    listen_port  => '9002',
    requirepass  => 'mySecurePassword'
  }
}

```

