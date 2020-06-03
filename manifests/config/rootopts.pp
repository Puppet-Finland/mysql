#
# == Define: pf_mysql::config::rootopts
#
# Setup options specific to the MySQL 'root' user.
#
# == Parameters
#
# [*password*]
#   The default database user password.
#
class pf_mysql::config::rootopts
(
    $password
)
{
    pf_mysql::config::useropts { 'root-useropts':
        owner    => 'root',
        dbuser   => 'root',
        password => $password,
    }
}
