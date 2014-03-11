#
# == Define: mysql::packetfilter::allow_ipv4
#
# Allow traffic to MySQL server through the firewall from the specified IP. Aped 
# from bacula::storagedaemon::packetfilter::allow_ip.
#
define mysql::packetfilter::allow_ipv4 {

    firewall { "009 ipv4 accept mysql from ${title}":
        provider => 'iptables',
        chain  => 'INPUT',
        proto => 'tcp',
        # Set the allowable source address, unless 'any', in which case the
        # 'source' parameter is left undefined.
        source => $title ? {
            'any' => undef,
            default => $title,
        },
        dport => 3306,
        action => 'accept',
    }
}
