#
# == Class: mysql::params
#
# Defines some variables based on the operating system
#
class mysql::params {

    case $::osfamily {
        'RedHat': {
            $package_name = 'mysql-server'
            $mysql_executable = '/usr/bin/mysql'
            $pidfile = '/var/run/mysqld/mysqld.pid'
            $service_name = 'mysqld'

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
        }
        'Debian': {
            $package_name = 'mysql-server'
            $mysql_executable = '/usr/bin/mysql'
            $service_name = 'mysql'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $pidfile = '/var/run/mysqld/mysqld.pid'
        }
        'FreeBSD': {
            $package_name = 'mysql55-server'
            $mysql_executable = '/usr/local/bin/mysql'
            $service_name = 'mysql-server'
            $service_start = "/usr/local/etc/$service_name start"
            $service_stop = "/usr/local/etc/$service_name stop"
            $pidfile = "/var/db/mysql/${::fqdn}.pid"
        }
        default: {
            $package_name = 'mysql-server'
            $service_name = 'mysql'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $pidfile = '/var/run/mysqld/mysqld.pid'
        }
    }
}
