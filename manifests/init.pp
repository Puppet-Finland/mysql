#
# == Class: mysql
#
# Class for installing and configuring MySQL server. Currently does not support 
# MySQL server configuration.
#
# [*email*]
#   Email address for notifications from monit. Defaults to top-scope variable 
#   $::servermonitor.
#
# == Parameters
#
# None at the moment
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
    $email = $::servermonitor
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysql', 'true') != 'false' {

    include mysql::install
    include mysql::service

    if tagged('monit') {
        class { 'mysql::monit':
            monitor_email => $email,
        }
    }

}
}
