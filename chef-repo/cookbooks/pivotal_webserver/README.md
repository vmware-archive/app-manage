pivotal_webserver Cookbook
==========================
This cookbook provides a resource, 'webserver_instance', which installs and creates a Pivotal Web Server.

Requirements
------------
#### Cookbooks
- pivotal_repo - Required to set up the necessary packages.

Usage
-----
#### pivotal_webserver::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pivotal_webserver]"
  ]
}
```

License
-------
This cookbook is licensed under the Apache 2.0 License. It uses software which is licensed under commercial licenses.

