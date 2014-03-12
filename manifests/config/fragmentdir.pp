#
# == Class: mysql::config::fragmentdir
#
# Ensure a configuration file fragment dir for my.cnf fragments is enabled. This 
# class will handle both creation of the directory (if necessary) and enabling 
# it in my.cnf (if necessary).
#
class mysql::config::fragmentdir {

    include os::params
    include mysql::params

    file {  'mysql-my.cnf.d':
        name   => "${mysql::params::fragment_dir}",
        ensure => directory,
        owner  => root,
        group  => "${::os::params::admingroup}",
        mode   => 755,
        require => Class['mysql::install'],
    }
}
