#
# == Class: mysql::install
#
# Install MySQL or MariaDB server
#
class mysql::install
(
    $use_mariadb_repo

) inherits mysql::params
{

    $package_name = $use_mariadb_repo ? {
        /(yes|stable|testing)/  => $::mysql::params::mariadb_package_name,
        'no'                    => $::mysql::params::mysql_package_name,
        default                 => $::mysql::params::mysql_package_name,
    }

    package { 'mysql-server':
        ensure  => installed,
        name    => $package_name,
        require => Class['mysql::prequisites'],
    }
}
