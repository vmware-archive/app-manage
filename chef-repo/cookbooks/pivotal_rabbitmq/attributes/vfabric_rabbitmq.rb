

# We need to override soem of the defaults
node.override['rabbitmq']['version'] = "3.2.1"
node.override['rabbitmq']['package-release'] = "3"

case node['platform_family']
when 'debian'
  # For Ubuntu the Pivotal Package names are the same as the distro versions but on RHEL they have vfabric- in front of their names
  node.override['rabbitmq']['use_distro_version'] = "true"
when 'rhel'
  if (node['platform_version'].start_with?("5"))
    rhel = 5
  else
    rhel = 6
  end
    node.override['rabbitmq']['package'] = "http://packages.gopivotal.com/pub/rpm/rhel5/vfabric/5.3/x86_64/vfabric-rabbitmq-server-#{node['rabbitmq']['version']}-#{node['rabbitmq']['pacakge-release']}.x86_64.rpm"
end

