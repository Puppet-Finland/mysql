class mysql::config::bindaddress
(
    $bind_address
)
{
    include os::params
    include mysql::params

    file { 'mysql-bindaddress.cnf':
        name => "${::mysql::params::fragment_dir}/bindaddress.cnf",
        ensure => present,
        content => template('mysql/bindaddress.cnf.erb'),
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 644,
        require => Class['mysql::config::fragmentdir'],
    }
}
