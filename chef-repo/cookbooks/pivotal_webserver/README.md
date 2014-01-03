pivotal_webserver Cookbook
==========================
This cookbook provides a resource, 'webserver_instance', which installs and creates a Pivotal Web Server.

Requirements
------------
#### Cookbooks
- pivotal_repo - Required to set up the necessary packages.

Actions
-------

- :stop - Tells chef to stop the instance, if running
- :start - Tells chef to start the instance, if not already running
- :delete - Stops the instance and removes the entire contents of the instance directory. Caution: This action is destructive

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
  server_admin "me@example.com"
  port "8085"
end
```

If you need to delete a created instance you can use the following in your recipe
```ruby
webserver_instance "foo" do
  action :delete
end
```
Note: When deleting an instance the entire directory is recursively deleted.

License
-------
This cookbook is licensed under the Apache 2.0 License. It uses software which is licensed under commercial licenses.

