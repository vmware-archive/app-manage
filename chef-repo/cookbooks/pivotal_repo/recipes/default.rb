#
# Cookbook Name:: pivotal_repo
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when 'redhat', 'centos'
  include_recipe 'pivotal_repo::_rhel'
when 'ubuntu'
  include_recipe 'pivotal_repo::_ubuntu'
end
