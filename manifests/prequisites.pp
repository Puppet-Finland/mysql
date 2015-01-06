#
# == Class: mysql::prequisites
#
# Things to do before installing mysql/mariadb
#
class mysql::prequisites
(
    $root_password

) inherits mysql::params
{
    if $::osfamily == 'Debian' {
        class { 'mysql::prequisites::debian':
            root_password => $root_password,
        }
    }
}
