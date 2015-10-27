#
# == Class: mysql::params
#
# Defines some variables based on the operating system
#
class mysql::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {

            case $::operatingsystemmajrelease {
                '6': {
                    $mysql_package_name = 'mysql-server'
                    $service_name = 'mysqld'
                    $pidfile = '/var/run/mysqld/mysqld.pid'
                }
                '7': {
                    $mysql_package_name = 'mariadb-server'
                    $service_name = 'mariadb'
                    $pidfile = '/var/run/mariadb/mariadb.pid'
                }
                default: {
                    fail("Unsupported RedHat major release: ${::operatingsystemmajrelease}")
                }
            }

            $mariadb_package_name = 'mariadb-server'
            $client_executable = '/usr/bin/mysql'
            $mktemp_executable = '/bin/mktemp'
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

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
