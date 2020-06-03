#
# == Class: pf_mysql::config::bindaddress
#
# Configure the bind address for MySQL
#
class pf_mysql::config::bindaddress
(
    String $bind_address

) inherits pf_mysql::params
{

    file { 'pf_mysql-bindaddress.cnf':
        ensure  => present,
        name    => "${::pf_mysql::params::fragment_dir}/bindaddress.cnf",
        content => template('pf_mysql/bindaddress.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['pf_mysql::config::fragmentdir'],
    }
}
