#
# == Define: mysql::database
#
# Create an empty MySQL/MariaDB database
#
# == Parameters
#
# [*title*]
#   The resource $title determines the name of the database to create or remove.
# [*ensure*]
#   Status of the database. Valid values are 'present' (default) and 'absent'.
# [*mysql_user*]
#   MySQL user with rights to create the specified database. Defaults to 'root'.
# [*mysql_passwd*]
#   Password for the above user.
# [*use_root_defaults*]
#   Defines whether to load /root/.my.cnf or not. It is assumed that it contains 
#   MySQL credentials for the root user. Valid values are 'yes' and 'no' 
#   (default).
#
define mysql::database
(
    $ensure = 'present',
    $mysql_user = 'root',
    $mysql_passwd = undef,
    $use_root_defaults = 'no'
)
{

    # Get the database name from the $title
    $database = $title

    if $use_root_defaults == 'yes' {
        $basecmd = "${::mysql::params::client_executable} --defaults-extra-file=/root/.my.cnf -e"
    } else {
        if $mysql_passwd {
            $basecmd = "${::mysql::params::client_executable} -u ${mysql_user} -p ${mysql_passwd} -e"
        } else {
            $basecmd = "${::mysql::params::client_executable} -u ${mysql_user} -e"
        }
    }

    if $ensure == 'present' {
        exec { "mysql-create-database-${database}":
            command => "${basecmd} \"CREATE DATABASE ${database}\"",
            unless  => "${basecmd} \"SHOW DATABASES\"|grep ${database}",
            require => Class['mysql::config::rootopts'],
        }
    } elsif $ensure == 'absent' {
        exec { "mysql-drop-database-${database}":
            command => "${basecmd} \"DROP DATABASE ${database}\"",
            onlyif  => "${basecmd} \"SHOW DATABASES\"|grep ${database}",
            require => Class['mysql::config::rootopts'],
        }
    } else {
        fail("Invalid value ${ensure} for parameter \$ensure!")
    }
}
