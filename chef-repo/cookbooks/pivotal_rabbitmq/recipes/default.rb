
group "rabbitmq"

if (node['platform'] == 'ubuntu')
  include_recipe "erlang::esl"
end
include_recipe 'rabbitmq::default'

