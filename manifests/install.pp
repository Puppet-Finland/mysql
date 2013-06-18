#
# == Class: mysql::install
#
# Install MySQL server
#
class mysql::install {

    package { 'mysql-server':
        ensure => installed,
        name => 'mysql-server',
    }
}
