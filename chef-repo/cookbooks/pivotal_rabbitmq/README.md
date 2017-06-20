pivotal_rabbitmq Cookbook
=========================

This cookbook wraps around the Opscode RabbitMQ Cookbook to override attributes so that Pivotal RabbitMQ will be installed instead of the Open Source Licensed Version

Requirements
------------
#### cookbooks
- `pivotal_repo` - To install the necessary apt/yum repository
- `rabbitmq` -The OpsCode RabbitMQ Cookbook.
- `erlang` - For Erlang Solutions Apt. 
- The above cookbooks also depend on yum, apt, yum-epel, and yum-erlang_solutions

### chef
- Version 11.x required for dependencies to function properly

Usage
=====
Simply include the default recipe and then this cookbook may be used just like the [rabbitmq cookbook](https://github.com/opscode-cookbooks/rabbitmq). Please
see the documentation of the [rabbitmq cookbook](https://github.com/opscode-cookbooks/rabbitmq) for usage of that cookbook.

```ruby
include_recipe "pivotal_rabbitmq"
```

The default recipe simply installs and configures RabbitMQ

There is one exception and that is with plugins. The OpsCode plugin resource isn't compatible with Pivotal RabbitMQ. There is a new resource called pivotal_rabbitmq_plugin. The usage is identical to that in the OpsCode plugin except it handles the Pivotal version of RabbitMQ

```ruby
pivotal_rabbitmq_plugin "rabbitmq_stomp" do
  action :enable
end

pivotal_rabbitmq_plugin "rabbitmq_management" do
  action :enable
  notifies :restart, "service[rabbitmq-server]"
end

```

License
-------------------
Apache 2.0 License. This cookbook installs software which is subject to commercial license terms.
