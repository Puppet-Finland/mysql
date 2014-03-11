#
# == Define: mysql::user
#
# Manage a MySQL user.
#
# This define supports both adding and removing users, but depends on the system 
# root user being able to login to MySQL without entering a password; in 
# practice, this is achieved by having a properly configured /root/.my.cnf.
#
# == Parameters
#
# [*status*]
#   Status of the user. Currently only supported value is 'present' (default). 
#   Later on 'absent' can be added fairly easily.
# [*user*]
#   The MySQL username. If omitted, resource $title is used.
# [*password*]:
#   User's password
# [*host*]
#   The hostname or IP from which connections are allowed for this user. This is 
#   required because in MySQL 'john'@'localhost' is not the same user as, say, 
#   'john'@'server'. Defaults to 'localhost'.
#
define mysql::user
(
    $status = 'present',
    $user = '',
    $password,
    $host = 'localhost'
)
{

    include mysql::params

    # Set the username
    $user_value = $user ? {
        '' => $title,
        default => $user
    }

    $params = '--defaults-extra-file=/root/.my.cnf'

    if $status == 'present' {
        exec { "mysql-create-user-${user_value}-at-${host}":
            command => "${::mysql::params::mysql_executable} ${params} -e \"GRANT USAGE ON *.* TO '${user_value}'@'${host}' IDENTIFIED BY '${password}';\"",
        }
    } elsif $status == 'absent' {
        exec { "mysql-drop-user-${user_value}-at-${host}":
            command => "${::mysql::params::mysql_executable} ${params} -e \"DROP USER '${user_value}'@'${host}';\"",
            onlyif  => "${::mysql::params::mysql_executable} ${params} -e \"SHOW GRANTS FOR '${user_value}'@'${host}';\"",
        }
    } else {
        notify { "Value of the \$status parameter (\"${status}\") for a mysql::user resource is invalid. Supported values are 'present' and 'absent'.":
            loglevel => warning,
        }
    }
}
