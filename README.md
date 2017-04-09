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

#### 1) Start containers:

* `docker-compose up`

```
   Name                  Command               State                   Ports                  
----------------------------------------------------------------------------------------------
database       docker-entrypoint.sh mysqld      Up      3306/tcp                               
idp            java -Didp.home=/opt/shibb ...   Up      443/tcp, 80/tcp, 0.0.0.0:443->8443/tcp
keystone       /bin/sh -c /bin/bash -x ./ ...   Up      0.0.0.0:5000->5000/tcp                 
ldap           /container/tool/run              Up      389/tcp, 636/tcp                       
phpldapadmin   /container/tool/run              Up      443/tcp, 80/tcp        
```

#### 2) Initialize federation stuff like groups, projects, mappings, etc:

`docker exec -it keystone /bin/bash -x /home/keystone/bootstrap/keystone/init-federation.sh`

#### 3) Try to get unscoped token via Idp SSO (use browser):

`http://172.22.0.6:5000/v3/OS-FEDERATION/identity_providers/shibboleth/protocols/saml2/auth`

 - Password to everything: `r00tme`.
 - Existing users (stored in LDAP): `dm` and `admin`

#### 4) Try to get scoped token via SAML2 ECP (non-browsing access) using next openrc:

```
#!/bin/bash
export OS_AUTH_TYPE="v3samlpassword"
export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_DOMAIN_NAME="default"
export OS_IDENTITY_PROVIDER="shibboleth"
export OS_IDENTITY_PROVIDER_URL="http://idp/idp/profile/SAML2/SOAP/ECP"
export OS_USERNAME="dm"
export OS_PASSWORD="r00tme"
export OS_AUTH_URL="http://keystone:5000/v3"
export OS_PROTOCOL="saml2"
```
