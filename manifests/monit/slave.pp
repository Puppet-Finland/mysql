#
# == Class: mysql::monit::slave
#
# Verify that mysql slave is replicating properly
#
class mysql::monit::slave
(
    $monitor_email = $::servermonitor,
    $mysql_user,
    $mysql_password,
    $max_seconds_behind_master = '600'
)
{

    include monit::params

    # Monit fragment for handling mysql replication checks
    monit::fragment { 'mysql-mysql-replication.monit':
        modulename => 'mysql',
        basename => 'mysql-replication',
    }

    # The actual script that checks if there are replication problems
    file { 'mysql-mysql-replication.sh':
        ensure => present,
        name => "${::monit::params::fragment_dir}/mysql-replication.sh",
        content => template('mysql/mysql-replication.sh.erb'),
        owner => root,
        group => root,
        mode => 700,
        require => Class['monit::config'],
    }

}
