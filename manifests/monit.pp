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

    include mysql::params

    monit::fragment { 'mysql-mysql.monit':
        modulename => 'mysql',
    }
}
