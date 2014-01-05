
node.override['rabbitmq']['version'] = "3.2.1"
node.override['rabbitmq']['package-release'] = "3"

case node['platform_family']
when 'debian'
  node.override['rabbitmq']['use_distro_version'] = "true"
when 'rhel'
  if (node['platform_version'].start_with?("5"))
    rhel = 5
  else
    rhel = 6
  end
    node.override['rabbitmq']['package'] = "http://packages.gopivotal.com/pub/rpm/rhel5/vfabric/5.3/x86_64/vfabric-rabbitmq-server-#{node['rabbitmq']['version']}-#{node['rabbitmq']['pacakge-release']}.x86_64.rpm"
end

