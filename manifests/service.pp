#
# == Class: pf_mysql::service
#
# Configure MySQL to start on boot
#
class pf_mysql::service inherits pf_mysql::params {

    service { 'pf_mysql-pf_mysql':
        enable  => true,
        name    => $::pf_mysql::params::service_name,
        require => Class['pf_mysql::install'],
    }
}
