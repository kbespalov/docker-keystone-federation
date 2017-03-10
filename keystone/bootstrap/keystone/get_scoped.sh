#!/bin/bash


UNSCOPED_TOKEN=ee040e2dc78049529d34f09bb177b489
SP_KEYSTONE_V3_URL=http://keystone:5000/v3/
DOMAIN=Federated
PROJECT=fedenration

# exchange the unscoped token for a scoped token
curl -v -s -X POST -H "X-Auth-Token: $UNSCOPED_TOKEN" -H "Content-Type: application/json" -d '{"auth":{"identity":{"methods":["saml2"],"saml2":{"id":"'"$UNSCOPED_TOKEN"'"}},"scope":{"project":{"domain": {"name": "'"$DOMAIN"'"},"name":"'"$PROJECT"'"}}}}' $SP_KEYSTONE_V3_URL/auth/tokens >catalog.txt 2>scoped.txt
if [ "$?" != "0" ] || grep -q 401 scoped.txt; then
    echo Could not obtain scoped token and catalog from service provider. See scoped.txt and catalog.txt for details.
    exit 1
fi

SCOPED_TOKEN=`awk '/X-Subject-Token/{print $3}' scoped.txt`
