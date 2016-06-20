#
# == Class: mysql::config
#
# Configure MySQL server
#
class mysql::config
(
    Optional[String] $bind_address,
    Optional[String] $sql_mode,
    Boolean          $manage_root_my_cnf,
    Optional[String] $root_password

) inherits mysql::params
{

    include ::mysql::config::fragmentdir

    if $bind_address {
        class { '::mysql::config::bindaddress':
            bind_address => $bind_address,
        }
    }

    if $sql_mode {
        class { '::mysql::config::sqlmode':
            sql_mode => $sql_mode,
        }
    }

    if $manage_root_my_cnf {
        class { '::mysql::config::rootopts':
            password => $root_password,
        }
    }

}
