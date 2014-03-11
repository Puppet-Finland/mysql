#
# == Define: mysql::grant
#
# Manage MySQL user privileges.
#
# This define supports both adding and removing privileges. Interestingly 
# MySQL/MariaDB does not seem to mind if the database being granted access to 
# does not exist; the end result is simply that there are privileges pointing to 
# non-existing databases. For discussion about root logins to MySQL have a look 
# at the mysql::user define.
#
# == Parameters
#
# [*status*]
#   Status of the grant. Valid values 'present' and 'absent'. Defaults to 
#   'present'.
# [*user*]
#   The MySQL username to grant access for.
# [*host*]
#   The hostname or IP part of the user definition. Defaults to 'localhost'. For 
#   discussion have a look at the mysql::user define.
# [*database*]
#   The database to grant privileges to. If no database is defined, assume '*' 
#   (all databases).
# [*privileges*]
#   A comma-separated (string) list of privileges given to the user database. 
#   For example 'STATUS', 'ALL' or 'SELECT,UPDATE'. Defaults to 'USAGE' (=no 
#   privileges) for safety.
#
define mysql::grant
(
    $status = 'present',
    $user,
    $host = 'localhost',
    $database = '*',
    $privileges = 'USAGE'
)
{
    include mysql::params

    $params = '--defaults-extra-file=/root/.my.cnf'

    if $status == 'present' {
        # See mysql::user for rationale on the backticks and backslashes.
        exec { "mysql-grant-${privileges}-for-${user}-to-${database}":
            command => "${::mysql::params::mysql_executable} ${params} -e \"GRANT ${privileges} ON ${database}.* TO '${user}'@'${host}';\"",
            onlyif  => "${::mysql::params::mysql_executable} ${params} -e \"SHOW GRANTS FOR '${user}'@'${host}';\"",
        }
    } elsif $status == 'absent' {
        exec { "mysql-revoke-${privileges}-for-${user}-to-${database}":
            command => "${::mysql::params::mysql_executable} ${params} -e \"REVOKE ${privileges} ON ${database}.* FROM '${user}'@'${host}';\"",
            onlyif  => "${::mysql::params::mysql_executable} ${params} -e \"SHOW GRANTS FOR '${user}'@'${host}';\"",
        }
    } else {
        notify { "Value of the \$status parameter (\"${status}\") in a mysql::grant resource is invalid. Supported values are 'present' and 'absent'.":
            loglevel => warning,
        }
    }    
}
