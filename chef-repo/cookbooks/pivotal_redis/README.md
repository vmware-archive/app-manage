pivotal_redis Cookbook
======================
This cookbook provides a resource, 'redis_instance', which installs Pivotal Redis and allows the user to configure instances of redis

Requirements
------------
#### Cookbooks
- pivotal_repo

Options
----------
#### pivotal_redis::redis_instance

All options corespond to redis.conf options with the exception that any redis.conf option which contains a hyphen(-). In this case the hyphen(-) has been replaced with an underscore(_). See Usage for example.

Usage
-----
#### redis_instance

Be sure to include the Cookbook in your runlist. There is no default recipe so no action will be taken.
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pivotal_redis]"
  ]
}
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
