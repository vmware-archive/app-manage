
default['rabbitmq']['version'] = "3.2.1"

case node['platform_family']
when 'debian'
  default['rabbitmq']['use_distro_version'] = "true"
when 'rhel'
  if (node['platform_version'].start_with?("5"))
    default['rabbitmq']['package'] = "http://packages.gopivotal.com/pub/rpm/rhel5/vfabric/5.3/x86_64/vfabric-rabbitmq-server-3.2.1-3.x86_64.rpm"
  elsif (node['platform_version'].start_with?("6"))
    default['rabbitmq']['package'] = "http://packages.gopivotal.com/pub/rpm/rhel6/vfabric/5.3/x86_64/vfabric-rabbitmq-server-3.2.1-3.x86_64.rpm"
  end
end

