#
# == Class: pf_mysql::config::sqlmode
#
# Configure the SQL mode for MySQL
#
class pf_mysql::config::sqlmode
(
    String $sql_mode

) inherits pf_mysql::params
{

    file { 'pf_mysql-sqlmode.cnf':
        ensure  => present,
        name    => "${::pf_mysql::params::fragment_dir}/sqlmode.cnf",
        content => template('pf_mysql/sqlmode.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['pf_mysql::config::fragmentdir'],
    }
}
