#!/bin/sh


/usr/bin/memcached -u root & >/dev/null || true
a2ensite keystone
service shibd start
service apache2 restart

if [ ! -f /home/keystone/bootstrap/bootstraped ]
then

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

/bin/bash -x /home/keystone/bootstrap/keystone/init-federation.sh
echo "ok" > /home/keystone/bootstrap/bootstraped
fi

tail -f /var/log/apache2/keystone.log
