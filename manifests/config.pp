#
# == Class: mysql::config
#
# Configure MySQL server
#
class mysql::config
(
    $bind_address,
    $manage_root_my_cnf,
    $root_password

) inherits mysql::params
{

    include ::mysql::config::fragmentdir

    if $bind_address {
        class { '::mysql::config::bindaddress':
            bind_address => $bind_address,
        }
    }

    if $manage_root_my_cnf {
        class { '::mysql::config::rootopts':
            password => $root_password,
        }
    }

}
