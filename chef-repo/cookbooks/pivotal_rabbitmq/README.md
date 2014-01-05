pivotal_rabbitmq Cookbook
=========================
This cookbook wraps around the Opscode RabbitMQ Cookbook to override attributes so that vFabric RabbitMQ will be installed instead of the Open Source Licensed Version


Requirements
------------
#### cookbooks
- `rabbitmq` -The OpsCode RabbitMQ Cookbook.
- `esl-erlang` - The Erlang Solutions Apt Cookbook. 


Usage
=====
Simply include the default recipe and then this cookbook may be used just like the [rabbitmq cookbook](https://github.com/opscode-cookbooks/rabbitmq)

```ruby
include_recipe "pivotal_rabbitmq"
```

The default recipe simply installs and configures RabbitMQ

License
-------------------
Apache 2.0 License. This cookbook installs software which is subject to commerical license terms.
