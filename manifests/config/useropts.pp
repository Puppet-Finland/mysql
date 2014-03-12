#
# == Define: mysql::config::useropts
#
# Set up a user-specific mysql configuration file
#
# == Parameters
#
# [*owner*]
#   Name of the system user for whom mysql is configured. Used in the config 
#   file path and permissions.
# [*dbuser*]
#   The default database user name.
# [*password*]
#   The default database user password.
#
define mysql::config::useropts
(
    $owner,
    $dbuser,
    $password
)
{   
    $config_file = $owner ? {
        'root'  => '/root/.my.cnf',
        default => "/home/${owner}/.my.cnf",
    }

    file { "${owner}-.my.cnf":
        name    => "${config_file}",
        ensure  => present,
        content => template('mysql/user-my.cnf.erb'),
        owner   => $owner,
        group   => $owner,
        mode    => 640,
    }
}
