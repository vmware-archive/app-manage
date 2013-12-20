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
redis_instance "default
```

The above example is the simplest form of usage. It will install pivotal-redis, if not already installed and the default configuration will be used. An instance listening on port 6379 will be started.

License
-------------------
This cookbook is licensed under the Apache License 2.0. The software installed by this cookbook may be subject to commercial licenses
