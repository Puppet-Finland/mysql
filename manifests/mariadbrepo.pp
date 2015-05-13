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

        include ::apt

        $key_options = $proxy_url ? {
            'none'  => undef,
            default => "http-proxy=\"${proxy_url}\"",
        }

        $location = $use_mariadb_repo ? {
            'yes'     => $::mysql::params::mariadb_stable_apt_repo_location,
            'stable'  => $::mysql::params::mariadb_stable_apt_repo_location,
            'testing' => $::mysql::params::mariadb_testing_apt_repo_location,
            default   => $::mysql::params::mariadb_stable_apt_repo_location,
        }

        apt::source { 'mariadb-aptrepo':
            location => $location,
            release  => $::lsbdistcodename,
            repos    => 'main',
            pin      => '502',
            key      => {
                'id'      => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
                'server'  => 'hkp://keyserver.ubuntu.com',
                'options' => $key_options,
            },
            include  => {
                'src' => true,
                'deb' => true,
            },
        }
    }
}
