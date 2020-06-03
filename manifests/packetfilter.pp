#
# == Class pf_mysql::packetfilter
#
# Configures packetfiltering rules for mysql
#
class pf_mysql::packetfilter
(
    Array[String] $allow_addresses_ipv4,
    Array[String] $allow_addresses_ipv6
)
{
    pf_mysql::packetfilter::allow_ipv4 { $allow_addresses_ipv4: }
    pf_mysql::packetfilter::allow_ipv6 { $allow_addresses_ipv6: }
}
