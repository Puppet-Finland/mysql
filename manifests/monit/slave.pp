#
# == Class: mysql::monit::slave
#
# Verify that mysql slave is replicating properly
#
# == Parameters
#
# [*ensure*]
#   The status of mysql slave monitoring. Valid values are 'present' (default) 
#   and 'absent'.
# [*monitor_email*]
#   Where to send email reports of replication problems. Defaults to global 
#   variable $::servermonitor.
# [*mysql_user*]
#   User used to connect to the mysql server.
# [*mysql_password*]
#   Password for the mysql user.
# [*max_seconds_behind_master*]
#   Maximum value of the "Seconds behind master" variable. In general, if the 
#   value is large or growing, then there is something wrong with replication. 
#   This value can be surprisingly large even in "normal" circumstances, so the 
#   default value is set to '3600'.
#
class mysql::monit::slave
(
    Enum['present','absent'] $ensure = 'present',
    String                   $monitor_email = $::servermonitor,
    String                   $mysql_user,
    String                   $mysql_password,
    Variant[String, Integer] $max_seconds_behind_master = '3600'

) inherits mysql::params
{

    include ::monit::params

    # Monit fragment for handling mysql replication checks
    @monit::fragment { 'mysql-mysql-replication.monit':
        ensure     => $ensure,
        modulename => 'mysql',
        basename   => 'mysql-replication',
        tag        => 'default',
    }

    # The actual script that checks if there are replication problems
    @file { 'mysql-mysql-replication.sh':
        ensure  => $ensure,
        name    => "${::monit::params::fragment_dir}/mysql-replication.sh",
        content => template('mysql/mysql-replication.sh.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0700',
        require => Class['monit::config'],
        tag     => 'monit',
    }

}
