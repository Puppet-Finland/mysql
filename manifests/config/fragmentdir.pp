#
# == Class: pf_mysql::config::fragmentdir
#
# Ensure a configuration file fragment dir for my.cnf fragments is enabled. This 
# class will handle both creation of the directory (if necessary) and enabling 
# it in my.cnf (if necessary).
#
class pf_mysql::config::fragmentdir inherits pf_mysql::params {

    file {  'pf_mysql-my.cnf.d':
        ensure  => directory,
        name    => $::pf_mysql::params::fragment_dir,
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0755',
        require => Class['pf_mysql::install'],
    }
}
