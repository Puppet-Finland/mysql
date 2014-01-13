#
# == Class: mysql::install
#
# Install MySQL server
#
class mysql::install {

    include mysql::params

    package { 'mysql-server':
        ensure => installed,
        name => "${::mysql::params::package_name}",
    }
}
