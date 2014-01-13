#
# == Class: mysql::monit
#
# Setups monit rules for mysql
#
class mysql::monit
(
    $monitor_email
)
{
    monit::fragment { 'mysql-mysql.monit':
        modulename => 'mysql',
    }
}
