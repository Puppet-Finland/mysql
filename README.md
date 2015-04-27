# mysql

A Puppet module for managing MySQL servers.

This module adds functionality by include optional mysql::config subclasses, 
which avoids the "parameter explosion" that is typical in complex modules. This 
means that the base module can be included safely on almost all mysql servers, 
while still allowing more complex setups to be realized.

# Module usage

* [Class: mysql](manifests/init.pp)
* [Class: mysql::config::innodb](manifests/config/innodb.pp)
* [Class: mysql::config::replication](manifests/config/replication.pp)
* [Define: mysql::grant](manifests/grant.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04 and 14.04

The following operating systems might work out of the box, but they have not 
been tested:

* CentOS 6
* FreeBSD 10

Other *NIX-style operating systems should work with some modifications.

For details see [params.pp](manifests/params.pp).
