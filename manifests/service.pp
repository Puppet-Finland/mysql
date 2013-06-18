#
# == Class: mysql::service
#
# Configure MySQL to start on boot
#
class mysql::service {

    service { 'service-mysql-mysql':
        enable => true,
        name => 'mysql',
        require => Class['mysql::install'],
    }
}
