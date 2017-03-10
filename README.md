# Docker-keystone-federation

Containerized keystone federation dev-environment with:
  - Shibboleth as Idp
  - OpenLDAP as idendity storage.
  - Keystone + mod_shibd as SP

How start to use:

1) Start containers:
`
    docker-compose up
`

2) Initialize federation stuff like groups, projects, mappings, etc:
`
      docker exec -it keystone /bin/bash -x /home/keystone/bootstrap/keystone/init-federation.sh
`

Password to everythink: `r00tme`
Existing users (stored in ldap): `dm` and `admin`
