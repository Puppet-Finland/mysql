#
# == Class: mysql
#
# Class for installing and configuring MySQL and MariaDB servers. Currently only 
# very basic configurations are covered by mysql::config in order to prevent the 
# amount of class parameters from exploding. If more specific or exotic 
# configurations are required, it's probably best to create a new interface 
# class based on this one, and add the extensions to it. Alternatively the other 
# parts of this module (install, service, monit, etc.) can be reused, and a more 
# static mysql config class and my.cnf template created.
#
# It seems that different operating systems (Debian, Ubuntu, CentOS, FreeBSD) 
# have taken very different approaches to managing mysql configurations. The 
# approach I've chosen is the Debian one, where configuration file fragments can 
# be added to configure the mysql server piece by piece. This also allows manual 
# and puppet-managed configurations to live side-by-side without really serious 
# issues like Puppet overwriting an entire manually-managed my.cnf accidentally. 
# Of course there is the possibility of conflicting configurations, which may 
# produce unexpected runtime configurations.
#
# Currently only Debian and Ubuntu are supported as far as mysql configuration 
# is concerned. However, the framework for extending configuration support to 
# other operating systems is in place.
#
# == Parameters
#
# [*manage_config*]
#   Whether to manage the configuration of MySQL/MariaDB server. Valid values 
#   'yes' (default) and 'no'.
# [*use_mariadb_repo*]
#   Use MariaDB's official software repositories. Valid values 'yes', 'stable', 
#   'testing', and 'no'. Values 'yes' and 'stable' install stable releases from 
#   MariaDB repos. Value 'testing' uses testing releases and 'no' (the default) 
#   uses whatever is available in the operating system's own repositories.
# [*proxy_url*]
#   The proxy URL used for fetching the MariaDB software repository public keys.
#   For example "http://proxy.domain.com:8888". Not needed if the node has
#   direct Internet connectivity, or if you're installing MariaDB from your
#   operating system repositories. Defaults to 'none' (do not use a proxy).
# [*bind_address*]
#   The address mysql server binds to. Use '0.0.0.0' to bind to all IPv4 
#   interfaces, '::' to bind to all IPv4 and IPv6 interfaces and an IPv4 or IPv6 
#   address to bind to that particular address. Alternatively use a hostname 
#   instead of an IP-address. Leave empty to not manage the bind address using 
#   Puppet (default). For further details, see
#
#   <https://dev.mysql.com/doc/refman/5.5/en/server-options.html>
#
# [*root_password*]
#   The MySQL root user's password. Leave empty to not manage it using Puppet. 
# [*allow_addresses_ipv4*]
#   A list of IPv4 address/network from which to allow connections. Currently 
#   only affects packet filtering rules. Use special value ['any'] to allow 
#   access from any IPv4 address. Defaults to ['127.0.0.1'].
# [*allow_addresses_ipv6*]
#   IPv6 address/network from which to allow connections. Currently only affects 
#   packet filtering rules. Use special value ['any'] to allow access from any 
#   IPv4 address. Defaults to ['::1'].
# [*email*]
#   Email address for notifications from monit. Defaults to top-scope variable 
#   $::servermonitor.
#
# == Examples
#
# include mysql
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class mysql
(
    $manage_config = 'yes',
    $use_mariadb_repo = 'no',
    $proxy_url = 'none',
    $bind_address = '',
    $root_password = '',
    $allow_addresses_ipv4 = ['127.0.0.1'],
    $allow_addresses_ipv6 = ['::1'],
    $email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysql', 'true') != 'false' {

    class { 'mysql::mariadbrepo':
        use_mariadb_repo => $use_mariadb_repo,
        proxy_url => $proxy_url,
    }

    class { 'mysql::install':
        use_mariadb_repo => $use_mariadb_repo,
    }


    if $manage_config == 'yes' {
        class { 'mysql::config':
            bind_address => $bind_address,
            root_password => $root_password,
        }
    }

    include mysql::service

    if tagged('packetfilter') {
        class { 'mysql::packetfilter':
            allow_addresses_ipv4 => $allow_addresses_ipv4,
            allow_addresses_ipv6 => $allow_addresses_ipv6,
        }
    }

    if tagged('monit') {
        class { 'mysql::monit':
            monitor_email => $email,
        }
    }
}
}
