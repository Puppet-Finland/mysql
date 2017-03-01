#
# == Define: mysql::packetfilter::allow_ipv6
#
# Allow traffic to MySQL server through the firewall from the specified IP. Aped 
# from bacula::storagedaemon::packetfilter::allow_ip.
#
define mysql::packetfilter::allow_ipv6 {

    $source_v6 = $title ? {
            'any'   => undef,
            default => $title,
    }

    @firewall { "009 ipv6 accept mysql from ${title}":
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        # Set the allowable source address, unless 'any', in which case the
        # 'source' parameter is left undefined.
        source   => $source_v6,
        dport    => 3306,
        action   => 'accept',
        tag      => 'default',
    }
}
