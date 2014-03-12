#
# == Class: mysql::config
#
# Configure MySQL server
#
class mysql::config
(
    $bind_address,
    $root_password
)
{

    include mysql::config::fragmentdir

    unless $bind_address == '' {
        class { 'mysql::config::bindaddress':
            bind_address => $bind_address,
        }
    }

    unless $root_password == '' {
        class { 'mysql::config::rootopts':
            password => $root_password,
        } 
    }

}
