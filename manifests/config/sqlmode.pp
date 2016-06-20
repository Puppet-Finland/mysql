#
# == Class: mysql::config::sqlmode
#
# Configure the SQL mode for MySQL
#
class mysql::config::sqlmode
(
    String $sql_mode

) inherits mysql::params
{

    file { 'mysql-sqlmode.cnf':
        ensure  => present,
        name    => "${::mysql::params::fragment_dir}/sqlmode.cnf",
        content => template('mysql/sqlmode.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['mysql::config::fragmentdir'],
    }
}
