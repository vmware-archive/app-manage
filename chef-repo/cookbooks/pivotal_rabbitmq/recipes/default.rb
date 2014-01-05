
group "rabbitmq"

if (node['platform'] == 'ubuntu')
  include_recipe "esl-erlang::esl"
end
include_recipe 'rabbitmq::default'

