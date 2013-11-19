## vFabric Web Server Puppet Module
##
## Copyright 2013 GoPivotal, Inc
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Configuration Information
##
##  $ensure
##    Default - running
##    Desired state of the redis server
##
##  $version
##    Default - latest
##    The version of the pivotal-redis package to install. The value of
##    latest will tell the package manager to use the latest available
##    in the repository. The version specified must be available to
##    the system to install.
##
##  The remainder of the variables are taken from redis.conf. Please see
##  that file for definitions. Default values match the defaults specified
##  in 2.6's redis.conf file

define redis (
  $ensure = running,
  $owner = 'redis',
  $group = 'pivotal',
  $version = 'latest',
  $listen_address = undef,
  $listen_port = '6379',
  $timeout = '0',
  $daemonize = undef,
  $tcp_keepalive = '0',
  $redis_loglevel = 'notice', #this has redis_ prefixed to avoid a conflict with puppet loglevel
  $logfile = undef,
  $syslog_enabled = 'no',
  $syslog_ident = 'redis',
  $syslog_facility = 'local0',
  $databases = '16',
  $save = [ '900 1', '300 10', '60 10000'],    #Array for each save line
  $stop_writes_on_bgsave_error = 'yes',
  $rdbcompression = 'yes',
  $rdbchecksum = 'yes',
  $dbfilename = 'dump.rdb',
  $dir = undef,
  $slaveof = '',
  $masterauth = '',
  $slave_serve_stale_data = 'yes',
  $slave_read_only = 'yes',
  $repl_ping_slave_period = '10',
  $repl_timeout = '60',
  $repl_disable_tcp_nodelay = 'no',
  $slave_priority = '100',
  $requirepass = '',
  $rename_command = '',  #Array of each rename command line
  $maxclients = '10000',
  $maxmemory = '',
  $maxmemory_policy = 'volatile-lru',
  $maxmemory_samples = '3',
  $appendonly = 'no',
  $appendfilename = 'appendonly.aof',
  $appendfsync = 'everysec',
  $no_appendfsync_on_rewrite = 'no',
  $auto_aof_rewrite_percentage = '100',
  $auto_aof_rewrite_min_size = '64mb',
  $lua_time_limit = '5000',
  $slowlog_log_slower_than = '10000',
  $slowlog_max_len = '128',
  $hash_max_ziplist_entries = '512',
  $hash_max_ziplist_value = '64',
  $list_max_ziplist_entries = '512',
  $list_max_ziplist_value = '64',
  $zset_max_ziplist_entries = '128',
  $zset_max_ziplist_value = '64',
  $activerehashing = 'yes',
  $client_output_buffer_limit = ['normal 0 0 0', 'slave 256mb 64mb 60', 'pubsub 32mb 8mb 60' ],
  $hz = '10',
  $aof_rewrite_incremental_fsync = 'yes'
) {

  if !defined(Class['redis::install']) {
    class { 'redis::install':
      version => $version
    }
  }

  redis::config {$listen_port:
    ensure                        => $ensure,
    owner                         => $owner,
    group                         => $group,
    require                       => Class['redis::install'],
    listen_address                => $listen_address,
    listen_port                   => $listen_port,
    timeout                       => $timeout,
    tcp_keepalive                 => $tcp_keepalive,
    redis_loglevel                => $redis_loglevel,
    logfile                       => $logfile,
    syslog_enabled                => $syslog_enabled,
    syslog_ident                  => $syslog_ident,
    syslog_facility               => $syslog_facility,
    databases                     => $databases,
    save                          => $save,
    stop_writes_on_bgsave_error   => $stop_writes_on_bgsave_error,
    rdbcompression                => $rdbcompression,
    rdbchecksum                   => $rdbchecksum,
    dbfilename                    => $dbfilename,
    dir                           => $dir,
    slaveof                       => $slaveof,
    masterauth                    => $masterauth,
    slave_serve_stale_data        => $slave_serve_stale_data,
    slave_read_only               => $slave_read_only,
    repl_ping_slave_period        => $repl_ping_slave_period,
    repl_timeout                  => $repl_timeout,
    repl_disable_tcp_nodelay      => $repl_disable_tcp_nodelay,
    slave_priority                => $slave_priority,
    requirepass                   => $requirepass,
    rename_command                => $rename_command,
    maxclients                    => $maxclients,
    maxmemory                     => $maxmemory,
    maxmemory_policy              => $maxmemory_policy,
    maxmemory_samples             => $maxmemory_samples,
    appendonly                    => $appendonly,
    appendfilename                => $appendfilename,
    appendfsync                   => $appendfsync,
    no_appendfsync_on_rewrite     => $no_appendfsync_on_rewrite,
    auto_aof_rewrite_percentage   => $auto_aof_rewrite_percentage,
    auto_aof_rewrite_min_size     => $auto_aof_rewrite_min_size,
    lua_time_limit                => $lua_time_limit,
    slowlog_log_slower_than       => $slowlog_log_slower_than,
    slowlog_max_len               => $slowlog_max_len,
    hash_max_ziplist_entries      => $hash_max_ziplist_entries,
    hash_max_ziplist_value        => $hash_max_ziplist_value,
    list_max_ziplist_entries      => $list_max_ziplist_entries,
    list_max_ziplist_value        => $list_max_ziplist_value,
    zset_max_ziplist_entries      => $zset_max_ziplist_entries,
    zset_max_ziplist_value        => $zset_max_ziplist_value,
    activerehashing               => $activerehashing,
    client_output_buffer_limit    => $client_output_buffer_limit,
    hz                            => $hz,
    aof_rewrite_incremental_fsync => $aof_rewrite_incremental_fsync,
  } ->
  redis::service{"redis-${listen_port}":
    ensure => $ensure,
    owner  => $owner,
    group  => $group,
    port   => $listen_port,
  }
}
