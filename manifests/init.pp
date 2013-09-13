#
# == Class: mysql
#
# Class to install and configure MySQL server. Currently does not support MySQL 
# server configuration.
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
class mysql {

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysql', 'true') != 'false' {

    include mysql::install
    include mysql::service
}
}
