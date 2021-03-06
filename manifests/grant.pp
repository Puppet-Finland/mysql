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
# [*user*]
#   The MySQL username to grant access for.
# [*ensure*]
#   Status of the grant. Valid values 'present' and 'absent'. Defaults to 
#   'present'.
# [*password*]:
#   User's password. Defaults to undef (no password).
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
    String                   $user,
    Enum['present','absent'] $ensure = 'present',
    Optional[String]         $password = undef,
    String                   $host = 'localhost',
    String                   $database = '*',
    String                   $privileges = 'USAGE'
)
{
    include ::mysql::params

    $db_quoted = $database ? { '*' => $database, default => "\\`${database}\\`" }
    $db_quoted_regexp = $database ? { '*' => '[*]', default => ".${database}." }
    $params = '--defaults-extra-file=/root/.my.cnf'
    $basecmd = "${::mysql::params::client_executable} ${params} -e"
    $add_grant = "GRANT ${privileges} ON ${db_quoted}.* TO '${user}'@'${host}'"
    $show_grants = "SHOW GRANTS FOR '${user}'@'${host}'"
    $grant_pattern = "GRANT ${privileges}.*ON.${db_quoted_regexp}\\.[*].TO.'${user}'@'${host}'"

    if $ensure == 'present' {
        # See mysql::user for rationale on the backticks and backslashes.
        exec { "mysql-grant-${privileges}-for-${user}-to-${database}-from-${host}":
            command => "${basecmd} \"${add_grant} IDENTIFIED BY '${password}';\"",
            unless  => "${basecmd} \"${show_grants}\"|grep \"${grant_pattern}\"",
            require => Class['mysql::config::rootopts'],
        }
    } elsif $ensure == 'absent' {
        exec { "mysql-revoke-${privileges}-for-${user}-to-${database}-from-${host}":
            command => "${basecmd} \"DROP USER '${user}'@'${host}';\"",
            onlyif  => "${basecmd} \"${show_grants}\"",
            require => Class['mysql::config::rootopts'],
        }
    } else {
        notify { "Value of the \$ensure parameter (\"${ensure}\") in a mysql::grant resource is invalid. Supported values are 'present' and 'absent'.":
            loglevel => warning,
        }
    }
}
