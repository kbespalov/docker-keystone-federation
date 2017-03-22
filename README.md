# Docker-keystone-federation

Containerized Openstack Keystone federation dev-environment.


----------
## Components: ##

  - Shibboleth as Idp
  - OpenLDAP as idendity storage.
  - Openstack Keystone + mod_shibd as SP


![Containers Schema](https://image.ibb.co/fnQUva/Screenshot_from_2017_03_20_11_19_08.png)

----------

## How start to use:

1) Start containers:

`docker-compose up`

2) Initialize federation stuff like groups, projects, mappings, etc:

`docker exec -it keystone /bin/bash -x /home/keystone/bootstrap/keystone/init-federation.sh`

3) Try to get unscoped token via Idp SSO (replace `keystone` with real IP address of container):

http://keystone:5000/v3/OS-FEDERATION/identity_providers/shibboleth/protocols/saml2/auth

 - Password to everything: `r00tme`.
 - Existing users (stored in LDAP): `dm` and `admin`

4) Also available SAML2 ECP (non-browsing access) support via next endpoint:

http://idp/idp/profile/SAML2/SOAP/ECP/
