#
# == Class: pf_mysql::mariadbrepo
#
# Setup MariaDB apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
# Proxy support requires a fairly recent version of apt module - 1.4.0 is known 
# to work.
#
class pf_mysql::mariadbrepo
(
    Enum['yes', 'stable', 'testing', 'no'] $use_mariadb_repo,
    String                                 $proxy_url

) inherits pf_mysql::params
{

    if $use_mariadb_repo =~ /(yes|stable|testing)/ {

        if $::osfamily == 'Debian' {
            include ::apt

            $key_options = $proxy_url ? {
                'none'  => undef,
                default => "http-proxy=\"${proxy_url}\"",
            }

            $location = $use_mariadb_repo ? {
                'yes'     => $::pf_mysql::params::mariadb_stable_apt_repo_location,
                'stable'  => $::pf_mysql::params::mariadb_stable_apt_repo_location,
                'testing' => $::pf_mysql::params::mariadb_testing_apt_repo_location,
                default   => $::pf_mysql::params::mariadb_stable_apt_repo_location,
            }

            apt::key { 'mariadb-aptrepo':
                id      => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
                server  => 'hkp://keyserver.ubuntu.com',
                options => $key_options,
            }

            apt::source { 'mariadb-aptrepo':
                location => $location,
                release  => $::lsbdistcodename,
                repos    => 'main',
                pin      => '502',
                include  => {
                    'src' => true,
                    'deb' => true,
                },
                require  => Apt::Key['mariadb-aptrepo'],
            }
        } else {
            fail("Invalid value ${use_mariadb_repo} for \$use_mariadb_repo parameter. MariaDB repositories not supported on ${::osfamily}.")
        }
    }
}
