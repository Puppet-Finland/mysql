#
# == Class: mysql::config::innodb
#
# Configure the InnoDB storage engine. This class has to be included manually 
# because adding it to the aggregate class would result in API explosion.
#
# == Parameters
#
# [*buffer_pool_size*]
#   The amount of RAM in bytes to reserve for the InnoDB buffer pool. This will 
#   improve performance when lookups tends to query the same data. Defaults to 
#   33554432 (32MB) to accommodate virtual machines with very little memory. In 
#   most cases this limit should be increased considerably. For details look 
#   here:
#
#   <https://dev.mysql.com/doc/refman/5.5/en/innodb-parameters.html>
#
# [*file_per_table*]
#   Store each table in a different InnoDB file, which is in general a good 
#   idea. Valid values 'ON' (default) and 'OFF'. For details refer to the above 
#   link.
#
class mysql::config::innodb
(
    $buffer_pool_size = 33554432,
    $file_per_table = 'ON'

) inherits mysql::params
{

    file { 'mysql-innodb.cnf':
        ensure  => present,
        name    => "${::mysql::params::fragment_dir}/innodb.cnf",
        content => template('mysql/innodb.cnf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['mysql::config::fragmentdir'],
    }
}
