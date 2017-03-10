#!/bin/sh
ldapadd -c -x -w r00tme -h 'ldap' -D 'cn=admin,dc=openstack,dc=com' \
        -f /home/keystone/bootstrap/ldap/domain.ldif
