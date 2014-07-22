#
# == Class: mysql::config::replication
#
# Configure MySQL master-slave replication. Works equally well for masters and 
# slaves. Refer to MySQL/MariaDB documentation for more information on the 
# parameters.
#
# == Parameters
#
# [*server_id*]
#   A globally unique, numeric ID for the replication peer. No default value.
# [*expire_logs_days*]
#   Purge binary logs that are older than this in days. Valid values are 0-99. 
#   Defaults to 0 (no expirations).
# [*max_binlog_size*]
#   The maximum size to which a single binary log can grow before a new one is 
#   created. Defaults to '100M'.
# [*log_slave_updates*]
#   Whether or not to log updates received from master to the slave's own binary 
#   log. This parameter should be set to 'OFF' (default) if the slave is to be 
#   used as a failover node for the master. If the slave is also a master 
#   (chained replication), then this parameter should be set to 'ON'.
# [*do_tables*]
#   An array of tables (wildcards) to replicate to this slave. By default this 
#   variable is empty.
# [*ignore_tables*]
#   An array of tables to _not_ replicate to this slave. By default this 
#   variable is empty. Results of combining this parameter with $do_tables 
#   parameter could be unexpected. For details, see
#
#   <https://dev.mysql.com/doc/refman/5.5/en/replication-rules-table-options.html>
#
class mysql::config::replication
(
    $server_id,
    $expire_logs_days = 0,
    $max_binlog_size = '100M',
    $log_slave_updates = 'OFF',
    $do_tables = [],
    $ignore_tables = []
)
{
    include os::params
    include mysql::params

    file { 'mysql-replication.cnf':
        name => "${::mysql::params::fragment_dir}/replication.cnf",
        ensure => present,
        content => template('mysql/replication.cnf.erb'),
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 644,
        require => Class['mysql::config::fragmentdir'],
    }
}
