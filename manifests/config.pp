#
# == Class: pf_mysql::config
#
# Configure MySQL server
#
class pf_mysql::config
(
    Optional[String] $bind_address,
    Optional[String] $sql_mode,
    Boolean          $manage_root_my_cnf,
    Optional[String] $root_password

) inherits pf_mysql::params
{

    include ::pf_mysql::config::fragmentdir

    if $bind_address {
        class { '::pf_mysql::config::bindaddress':
            bind_address => $bind_address,
        }
    }

    if $sql_mode {
        class { '::pf_mysql::config::sqlmode':
            sql_mode => $sql_mode,
        }
    }

    if $manage_root_my_cnf {
        class { '::pf_mysql::config::rootopts':
            password => $root_password,
        }
    }

}
