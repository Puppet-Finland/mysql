#
# == Class: pf_mysql::prequisites
#
# Things to do before installing pf_mysql/mariadb
#
class pf_mysql::prequisites
(
    $root_password

) inherits pf_mysql::params
{
    if $::osfamily == 'Debian' {
        class { '::pf_mysql::prequisites::debian':
            root_password => $root_password,
        }
    }
}
