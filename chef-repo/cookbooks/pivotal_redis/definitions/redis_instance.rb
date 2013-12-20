
# Rules for variables
#  * Variables match their redis.conf counerparts unless a hyphen is used. Hyphens are not allowed in ruby
#    variable names so we use an underscore instead.
#  * Default values here are taken from the default redis.conf

define :redis_instance,
  :action => "start",
  :owner => 'redis', # Name of the system user who owns the file belonging to this instance
  :group => 'pivotal', # Name of the system group who owns the file belonging to this instance
  :port => 6379,
  :timeout => 0,
  :tcp_keepalive => 0,  # This is the same thing as tcp-keepalive, but hyphens(-) aren't allowed in variable names in ruby so we use underscore(_) instead
  :loglevel => 'notice',
  :databases => 16,
  :save => ['900 1', '300 10', '60 10000'], # This array is looped and used to define "save" lines in the redis.conf file
  :stop_writes_on_bgsave_error => 'yes',
  :rdbcompression => 'yes',
  :rdbchecksum => 'yes',
  :dbfilename => 'dump.rdb',
  :slave_serve_stale_data => 'yes',
  :slave_read_only => 'yes',
  :repl_disable_tcp_nodelay => 'no',
  :slave_priority => 100,
  :appendonly => 'no',
  :appendfsync => 'everysec',
  :no_appendfsync_on_rewrite => 'no',
  :auto_aof_rewrite_percentage => 100,
  :auto_aof_rewrite_min_size => '64mb',
  :lua_time_limit => 5000,
  :slowlog_log_slower_than => 10000,
  :slowlog_max_len => 128,
  :hash_max_ziplist_entries => 512,
  :hash_max_ziplist_value => 64,
  :list_max_ziplist_entries => 512,
  :list_max_ziplist_value => 64,
  :set_max_intset_entries => 512,
  :zset_max_ziplist_entries => 512,
  :zset_max_ziplist_value => 64,
  :activerehashing => 'yes',
  :client_output_buffer_limit => ['normal 0 0 0', 'slave 256mb 64mb 60', 'pubsub 32mb 8mb 60' ],
  :hz => 10,
  :aof_rewrite_incremental_fsync => 'yes' do

  package "#{node['pivotal_redis']['package_name']}" do
    action :install
  end

  dir = params[:dir] ? params[:dir] : "/var/opt/pivotal/pivotal-redis/lib/#{params[:port]}"
  # On lucid the daemonize option should be no
  if params[:daemonize]
    daemonize = params[:daemonize]
  elsif node['platform'] == 'ubuntu' and node['platform_version'] == '10.04'
    daemonize = 'no'
  else
    daemonize = 'yes'
  end

  directory dir do
    owner params[:owner]
    group params[:group]
    mode 00755
    action :create
  end
  
  template "/etc/opt/pivotal/pivotal-redis/redis-#{@params[:port]}.conf" do
    source 'redis.conf.erb'
    owner params[:owner]
    group params[:group]
    mode 00644
    cookbook params[:cookbook] ? params[:cookbook] : 'pivotal_redis'
    variables(
      :dir => dir,
      :daemonize => daemonize,
      :params => params
    )
  end

  case node['platform']
  when 'ubuntu'
    link "/etc/init.d/redis-#{params[:port]}" do
      to '/lib/init/upstart-job'
    end

    template "/etc/init/redis-#{params[:port]}.conf" do
      source "redis.upstart-#{node['platform_version']}.erb"
      owner params[:owner]
      group params[:group]
      mode 00644
      cookbook params[:cookbook] ? params[:cookbook] : 'pivotal_redis'
      variables(
        :user => params[:owner],
        :port => params[:port]
      )
    end
    service "redis-#{params[:port]}" do
      action params[:action]
    end
  when 'redhat', 'centos'
    template "/etc/init.d/pivotal-redis-#{params[:port]}" do
      source "pivotal-redis.erb"
      owner params[:owner]
      group params[:group]
      mode 00554
      cookbook params[:cookbook] ? params[:cookbook] : 'pivotal_redis'
      variables(
        :user => params[:owner],
        :port => params[:port]
      )
    end
    service "pivotal-redis-#{params[:port]}" do
      action params[:action]
    end

  end
end
