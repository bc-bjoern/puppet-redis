# == Class: redis
#
# Install and configure a Redis server
#
# === Parameters
#
# All the redis.conf parameters can be passed to the class.
# Check the README.md file
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
#  class { redis:
#    $conf_port => '6380',
#    $conf_bind => '0.0.0.0',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2013 Felipe Salum, unless otherwise noted.
#
class redis (
  $package_ensure                   = 'present',
  $service_ensure                   = 'running',
  $service_enable                   = true,
  $conf_daemonize                   = 'yes',
  $conf_pidfile                     = '/var/run/redis/redis.pid',
  $conf_port                        = '6379',
  $conf_bind                        = '127.0.0.1',
  $conf_timeout                     = '0',
  $conf_loglevel                    = 'notice',
  $conf_logfile                     = '/var/log/redis/redis.log',
  $conf_syslog_enabled              = UNSET,
  $conf_syslog_ident                = UNSET,
  $conf_syslog_facility             = UNSET,
  $conf_databases                   = '16',
  $conf_save                        = UNSET,
  $conf_rdbcompression              = 'yes',
  $conf_dbfilename                  = 'dump.rdb',
  $conf_dir                         = '/var/lib/redis/',
  $conf_slaveof                     = UNSET,
  $conf_masterauth                  = UNSET,
  $conf_slave_server_stale_data     = 'yes',
  $conf_repl_ping_slave_period      = '10',
  $conf_repl_timeout                = '60',
  $conf_requirepass                 = UNSET,
  $conf_maxclients                  = UNSET,
  $conf_maxmemory                   = UNSET,
  $conf_maxmemory_policy            = UNSET,
  $conf_maxmemory_samples           = UNSET,
  $conf_appendonly                  = 'no',
  $conf_appendfilename              = UNSET,
  $conf_appendfsync                 = 'everysec',
  $conf_no_appendfsync_on_rewrite   = 'no',
  $conf_auto_aof_rewrite_percentage = '100',
  $conf_auto_aof_rewrite_min_size   = '64mb',
  $conf_slowlog_log_slower_than     = '10000',
  $conf_slowlog_max_len             = '1024',
  $conf_vm_enabled                  = 'no',
  $conf_vm_swap_file                = '/tmp/redis.swap',
  $conf_vm_max_memory               = '0',
  $conf_vm_page_size                = '32',
  $conf_vm_pages                    = '134217728',
  $conf_vm_max_threads              = '4',
  $conf_hash_max_zipmap_entries     = '512',
  $conf_hash_max_zipmap_value       = '64',
  $conf_list_max_ziplist_entries    = '512',
  $conf_list_max_ziplist_value      = '64',
  $conf_set_max_intset_entries      = '512',
  $conf_zset_max_ziplist_entries    = '128',
  $conf_zset_max_ziplist_value      = '64',
  $conf_activerehashing             = 'yes',
  $conf_include                     = UNSET,
) {

  include redis::params

  package { 'redis':
    ensure => $package_ensure,
    name   => $::redis::params::package,
  }

  service { 'redis':
    ensure     => $service_ensure,
    name       => $::redis::params::service,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['redis'],
  }

  file { $::redis::params::conf:
    path    => $::redis::params::conf,
    content => template('redis/redis.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service['redis'],
  }

  file { '/etc/logrotate.d/redis':
    path    => '/etc/logrotate.d/redis',
    content => template('redis/redis.logrotate.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

}
