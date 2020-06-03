#
# == Class: pf_mysql::prequisites::debian
#
# Do things that need to be done before anything else on Debian-based operating 
# systems. This class is currently only needed to feed the debconf system the 
# root password before the package is installed. If this class was not included 
# the freshly installed mysql/mariadb system would be in a limbo without a 
# functional root password and manual intervention using the debian-sys-maint 
# user would become necessary. This is not problem when installing mysql/mariadb 
# manually, because the Debian package asks the user interactively for the 
# password.
#
# Please note that this preseeding approach _only_ affects the initial install 
# of the package when /var/lib/mysql gets created. Subsequent changes to the 
# root password have to be done manually, even if the packages are purged. Only 
# the removal of /var/lib/mysql will allow this class to recreate the root 
# password with the defined value.
#
# The details of the preseeding process are described here:
#
# <http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html>
#
# The actual answers are placed into /var/cache/debconf/passwords.dat and could 
# (in theory) be added directly. However, it's safest to let 
# debconf-set-selections handle the logic to prevent unintended breakages.
#
class pf_mysql::prequisites::debian
(
    Optional[String] $root_password

) inherits pf_mysql::params
{

    # We need this directory or the rest of this class is doomed
    file { $::pf_mysql::params::config_dir:
        ensure => directory,
    }

    # Only try to configure debconf if the root password is set
    if $root_password {

        # As this module supports numerous distributions as well as package sources,
        # we can't be sure what version of mysql/mariadb will be available. Instead 
        # of adding tons of conditional logic to params.pp we just add proper 
        # answers into a file for all possible combinations.
        file { 'pf_mysql-debconf-selections':
            ensure  => present,
            name    => "${::pf_mysql::params::config_dir}/debconf-selections",
            content => template('pf_mysql/debconf-selections.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
            mode    => '0600',
            before  => Class['pf_mysql::install'],
            require => File['/etc/mysql'],
        }

        exec { 'pf_mysql-debconf-set-selections':
            command     => "debconf-set-selections ${::pf_mysql::params::config_dir}/debconf-selections",
            path        => [ '/usr/bin' ],
            user        => root,
            refreshonly => true,
            subscribe   => File['pf_mysql-debconf-selections'],
            before      => Class['pf_mysql::install'],
        }
    }
}
