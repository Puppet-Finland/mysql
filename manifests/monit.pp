#
# == Class: pf_mysql::monit
#
# Setups monit rules for mysql
#
class pf_mysql::monit
(
    String $monitor_email

) inherits pf_mysql::params
{

    @monit::fragment { 'pf_mysql-pf_mysql.monit':
        basename   => 'mysql',
        modulename => 'pf_mysql',
        tag        => 'default',
    }
}
