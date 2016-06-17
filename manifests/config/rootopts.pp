#
# == Define: mysql::config::rootopts
#
# Setup options specific to the MySQL 'root' user.
#
# == Parameters
#
# [*password*]
#   The default database user password.
#
class mysql::config::rootopts
(
    String $password
)
{
    mysql::config::useropts { 'root-useropts':
        owner    => 'root',
        dbuser   => 'root',
        password => $password,
    }
}
