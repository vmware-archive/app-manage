pivotal_webserver Cookbook
==========================
This cookbook provides a resource, 'webserver_instance', which installs and creates a Pivotal Web Server.

Requirements
------------
#### Cookbooks
- pivotal_repo - Required to set up the necessary packages.

Usage
-----
Your cookbook should depend on 'pivotal_webserver'

metadata.rb:
```ruby
depends `pivotal_webserver`
```

Then in your recipe you can use the webserver_instance resource. The name of the code block is used to name the instance. In the below example the instance name is "foo".
```ruby
webserver_instance "foo" do
  admin_email "me@example.com"
  port "8085"
end
```


License
-------
This cookbook is licensed under the Apache 2.0 License. It uses software which is licensed under commercial licenses.

