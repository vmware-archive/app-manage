pivotal_redis Cookbook
======================
This cookbook provides a resource, 'redis_instance', which installs Pivotal Redis and allows the user to configure instances of redis

This cookbook does installs the needed packages on the target nodes. When deleting instances it does not remove the package in case the admin wants to manually create and control instances. To remove the package use the Chef
 package resource in your recipe.

Requirements
------------
#### Cookbooks
- pivotal_repo

Actions
-------

- :stop - Tells chef to stop the instance, if running
- :start - Tells chef to start the instance, if not already running
- :delete - Stops the instance and removes the entire contents of the instance directory. Caution: This action is destructive. This action does NOT remove the .rpm/.deb package.

Options
----------
#### pivotal_redis::redis_instance

All options corespond to redis.conf options with the exception that any redis.conf option which contains a hyphen(-). In this case the hyphen(-) has been replaced with an underscore(_). See Usage for example.

Usage
-----
#### redis_instance

Your recipe should depend on 'pivotal_redis'

metadata.rb:
```ruby
depends 'pivotal_redis'
```

In your recipe you can use the redis_instance as follows. 

```ruby
redis_instance "default"
```
The above example is the simplest form of usage. It will install pivotal-redis, if not already installed and the default configuration will be used. An instance listening on port 6379 will be started.

If you need more advanced configuration it is available. All redis.conf options are available. Because hyphens are not allowed in names in ruby any redis option with a hyphen is changed to have an underscore.
```ruby
redis_instance "port-9001" do
  port 9001
end
```

On Ubuntu the redis package will automatically start an instance on port 6397. If you do not wish this instance to be running you can just stop it
```ruby
redis_instance "disable-default" do
  action :stop
end
```
The above example is the simplest form of usage. It will install pivotal-redis, if not already installed and the default configuration will be used. An instance listening on port 6379 will be started.

```ruby
redis_instance "example-of-underscore" do
  tcp_keepalive '30'   # This is the equivilent of "tcp-keepalive 30" in redis.conf
end
```

License
-------------------
This cookbook is licensed under the Apache License 2.0. The software installed by this cookbook may be subject to commercial licenses
