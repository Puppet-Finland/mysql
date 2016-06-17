#
# == Class: mysql::config::bindaddress
#
# Configure the bind address for MySQL
#
class mysql::config::bindaddress
(
    String $bind_address

) inherits mysql::params
{

    file { 'mysql-bindaddress.cnf':
        ensure  => present,
        name    => "${::mysql::params::fragment_dir}/bindaddress.cnf",
        content => template('mysql/bindaddress.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['mysql::config::fragmentdir'],
    }
}
