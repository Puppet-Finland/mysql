#
# == Class mysql::packetfilter
#
# Configures packetfiltering rules for mysql
#
class mysql::packetfilter
(
    $allow_addresses_ipv4,
    $allow_addresses_ipv6
)
{
    mysql::packetfilter::allow_ipv4 { $allow_addresses_ipv4: }
    mysql::packetfilter::allow_ipv6 { $allow_addresses_ipv6: }
}
