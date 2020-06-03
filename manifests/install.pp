#
# == Class: pf_mysql::install
#
# Install MySQL or MariaDB server
#
class pf_mysql::install
(
    String $use_mariadb_repo

) inherits pf_mysql::params
{

    $package_name = $use_mariadb_repo ? {
        /(yes|stable|testing)/  => $::pf_mysql::params::mariadb_package_name,
        'no'                    => $::pf_mysql::params::pf_mysql_package_name,
        default                 => $::pf_mysql::params::pf_mysql_package_name,
    }

    package { 'pf_mysql-server':
        ensure  => installed,
        name    => $package_name,
        require => Class['pf_mysql::prequisites'],
    }
}
