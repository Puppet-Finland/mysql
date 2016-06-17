#
# == Class: mysql::monit
#
# Setups monit rules for mysql
#
class mysql::monit
(
    String $monitor_email

) inherits mysql::params
{

    monit::fragment { 'mysql-mysql.monit':
        basename   => 'mysql',
        modulename => 'mysql',
    }
}
