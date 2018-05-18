# mysql

A Puppet module for managing MySQL servers.

This module adds functionality by include optional mysql::config subclasses, 
which avoids the "parameter explosion" that is typical in complex modules. This 
means that the base module can be included safely on almost all mysql servers, 
while still allowing more complex setups to be realized.

# Module usage

Example from [puppetfinland/librenms](https://github.com/Puppet-Finland/puppet-librenms)
that exposes much of the functionality of this module:

    class { '::mysql':
        bind_address         => $bind_address,
        allow_addresses_ipv4 => $allow_addresses_ipv4,
        sql_mode             => '',
        root_password        => $root_password,
    }
    
    class { '::mysql::config::innodb':
        file_per_table => true,
    }
    
    mysql::database { 'librenms':
        use_root_defaults => true,
    }
    
    mysql::grant { 'librenms':
        user       => $user,
        host       => $host,
        password   => $password,
        database   => 'librenms',
        privileges => 'ALL',
        require    => Mysql::Database['librenms'],
    }

For details see the following manifests:

* [Class: mysql](manifests/init.pp)
* [Class: mysql::config::innodb](manifests/config/innodb.pp)
* [Class: mysql::config::replication](manifests/config/replication.pp)
* [Define: mysql::grant](manifests/grant.pp)

