#!/bin/sh

if [[ -n "${bootstrap}" ]]; then

/bin/bash -x /home/keystone/bootstrap/mysql/init-db.sh
/bin/bash -x /home/keystone/bootstrap/ldap/init-domain.sh

keystone-manage db_sync
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap \
      --bootstrap-password r00tme \
      --bootstrap-username admin \
      --bootstrap-project-name admin \
      --bootstrap-role-name admin \
      --bootstrap-service-name keystone \
      --bootstrap-region-id RegionOne \
      --bootstrap-admin-url http://keystone:35357 \
      --bootstrap-public-url http://keystone:5000 \
      --bootstrap-internal-url http://keystone:5000

  echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
fi

/usr/bin/memcached -u root & >/dev/null || true

a2ensite keystone
a2enmod shib2
service shibd start

echo 'http://keystone:5000/v3/OS-FEDERATION/identity_providers/shib/protocols/saml2/auth'
echo '/bin/bash -x /home/keystone/bootstrap/keystone/init-federation.sh'

apache2ctl -D FOREGROUND
