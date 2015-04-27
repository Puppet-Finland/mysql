#
# == Class: mysql::params
#
# Defines some variables based on the operating system
#
class mysql::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $mysql_package_name = 'mysql-server'
            $client_executable = '/usr/bin/mysql'
            $mktemp_executable = '/bin/mktemp'
            $pidfile = '/var/run/mysqld/mysqld.pid'
            $service_name = 'mysqld'
            $fragment_dir = '/etc/my.cnf.d'
        }
        'Debian': {
            $mysql_package_name = 'mysql-server'
            $mariadb_package_name = 'mariadb-server'
            $client_executable = '/usr/bin/mysql'
            $mktemp_executable = '/bin/mktemp'
            $service_name = 'mysql'
            $pidfile = '/var/run/mysqld/mysqld.pid'
            $config_dir = '/etc/mysql'
            $fragment_dir = "${config_dir}/conf.d"

            if $::operatingsystem == 'Debian' {
                $mariadb_stable_apt_repo_location = 'http://mirror.netinch.com/pub/mariadb/repo/5.5/debian'
                $mariadb_testing_apt_repo_location = 'http://mirror.netinch.com/pub/mariadb/repo/10.0/debian'
            } elsif $::operatingsystem == 'Ubuntu' {
                $mariadb_stable_apt_repo_location = 'http://mirror.netinch.com/pub/mariadb/repo/5.5/ubuntu'
                $mariadb_testing_apt_repo_location = 'http://mirror.netinch.com/pub/mariadb/repo/10.0/ubuntu'
            }
        }
        'FreeBSD': {
            $mysql_package_name = 'mysql55-server'
            $client_executable = '/usr/local/bin/mysql'
            $mktemp_executable = '/usr/bin/mktemp'
            $service_name = 'mysql-server'
            $pidfile = "/var/db/mysql/${::fqdn}.pid"
            $config_dir = '/usr/local/etc'
            $fragment_dir = "${config_dir}/my.cnf.d"
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    $service_start = "${::os::params::service_cmd} ${service_name} start"
    $service_stop = "${::os::params::service_cmd} ${service_name} stop"
}
