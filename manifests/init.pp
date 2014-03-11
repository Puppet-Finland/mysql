#
# == Class: mysql
#
# Class for installing and configuring MySQL server. Currently does not support 
# MySQL server configuration.
#
# == Parameters
#
# [*allow_addresses_ipv4*]
#   A list of IPv4 address/network from which to allow connections. Use special 
#   value ['any'] to allow access from any IPv4 address. Defaults to 
#   ['127.0.0.1'].
# [*allow_addresses_ipv6*]
#   IPv6 address/network from which to allow connections. Use special value 
#   ['any'] to allow access from any IPv4 address. Defaults to ['::1'].
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
    $allow_addresses_ipv4 = ['127.0.0.1'],
    $allow_addresses_ipv6 = ['::1'],
    $email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysql', 'true') != 'false' {

    include mysql::install
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
