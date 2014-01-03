pivotal_repo Cookbook
=====================
This cookbook sets up the Pivotal package repository on the target node.

Requirements
------------

Only the following Linux Distributions are supported
- Red Hat Enterprise Linux (RHEL) 5.x or 6.x
- Ubuntu 10.04 or 12.04

Usage
-----
#### pivotal_repo::default
Just include `pivotal_repo` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pivotal_repo]"
  ]
}
```

The repository setup by this cookbook allows you to install pivotal packages in your recipes. 
```ruby
package 'vfabric-web-server' do
  action :install
end
```

The above example installs the vfabric-web-server .rpm or .deb, depending on the platform's distribution. 

License
-------------------
This cookbook is licensed under the Apache 2.0 License. This cookbook provides access to software which is licensed under commercial licenses.
