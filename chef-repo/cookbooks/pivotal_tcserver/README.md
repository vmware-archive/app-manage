pivotal_tcserver Cookbook
=========================
This cookbook provides a definition which installs vFabric tc Server and creates runtime instances.

Requirements
------------
#### cookbooks
- `pivotal_repo` - This is needed to install the Pivotal/vFabric package repository

Usage
-----

metadata.rb:
```ruby
depends `pivotal_webserver`
```

```ruby
tcruntime_instance "test1" do
  java_home "/usr"
end

```
