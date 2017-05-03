#!/bin/sh

. /home/keystone/bootstrap/keystone/openrcs/openrc.sh

# [1] Setup the next keystone entities:
# -- group: federated_users
# -- project: federation
# -- assingment: role _member_ for federated_users in federation

openstack group create federated_users --domain Default
openstack group create federated_admins --domain Default

openstack project create --domain Default federation

# add admin and member roles to project federation
openstack role create _member_
openstack role create admin

openstack role add --project federation --group federated_users _member_
openstack role add --project federation --group federated_admins _member_
openstack role add --project federation --group federated_admins admin

openstack mapping create \
        --rules /home/keystone/bootstrap/keystone/mappings/kb-no-group-mapping.json \
        ldap-map

openstack identity provider create \
        --remote-id http://idp/idp/shibboleth shibboleth

openstack federation protocol create \
        --identity-provider shibboleth \
        --mapping ldap-map saml2


# just for testing
openstack project create test
openstack role add --project test --user admin _member_
openstack role add --project test --user admin admin
