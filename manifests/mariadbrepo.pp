#
# == Class: mysql::mariadbrepo
#
# Setup MariaDB apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
# Proxy support requires a fairly recent version of apt module - 1.4.0 is known 
# to work.
#
class mysql::mariadbrepo
(
    $use_mariadb_repo,
    $proxy_url

) inherits mysql::params
{

    if ($::osfamily == 'Debian') and ($use_mariadb_repo =~ /(yes|stable|testing)/) {

        $key_options = $proxy_url ? {
            'none'  => undef,
            default => "http-proxy=\"${proxy_url}\"",
        }

        apt::key { 'mariadb-aptrepo':
            key         => '1BB943DB',
            key_server  => 'hkp://keyserver.ubuntu.com',
            key_options => $key_options,
        }

        $location = $use_mariadb_repo ? {
            'yes'     => $::mysql::params::mariadb_stable_apt_repo_location,
            'stable'  => $::mysql::params::mariadb_stable_apt_repo_location,
            'testing' => $::mysql::params::mariadb_testing_apt_repo_location,
            default   => $::mysql::params::mariadb_stable_apt_repo_location,
        }

        apt::source { 'mariadb-aptrepo':
            location          => $location,
            release           => $::lsbdistcodename,
            repos             => 'main',
            required_packages => undef,
            pin               => '502',
            include_src       => true,
            require           => Apt::Key['mariadb-aptrepo'],
        }
    }
}
