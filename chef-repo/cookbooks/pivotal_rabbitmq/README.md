pivotal_rabbitmq Cookbook
=========================
This cookbook wraps around the Opscode RabbitMQ Cookbook to override attributes so that vFabric RabbitMQ will be installed instead of the Open Source Licensed Version


Requirements
------------
#### cookbooks
- `rabbitmq` -The OpsCode RabbitMQ Cookbook.
- `esl-erlang` - The Erlang Solutions Apt Cookbook. 
- The above cookbooks also depend on yum, apt, yum-epel, yum-erlang_solutions, and erlang

Usage
=====
Simply include the default recipe and then this cookbook may be used just like the [rabbitmq cookbook](https://github.com/opscode-cookbooks/rabbitmq)

```ruby
include_recipe "pivotal_rabbitmq"
```

The default recipe simply installs and configures RabbitMQ

There is one exception and that is with plugins. The OpsCode plugin resource isn't compatible with vFabric RabbitMQ. There is a new resource called pivotal_rabbitmq_plugin. The usage is identical to that in the OpsCode plugin except it handles the vFabric version of RabbitMQ

```ruby
pivotal_rabbitmq_plugin "rabbitmq_stomp" do
  action :enable
end
```

License
-------------------
Apache 2.0 License. This cookbook installs software which is subject to commerical license terms.
