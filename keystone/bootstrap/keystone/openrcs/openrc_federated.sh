#!/bin/bash

# cleanup
unset `env | grep OS_ | awk -F '=' '{print $1}'| xargs`

export OS_AUTH_TYPE="v3samlpassword"
export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_DOMAIN_NAME="default"
export OS_PROJECT_NAME="test"
export OS_IDENTITY_PROVIDER="shibboleth"
export OS_IDENTITY_PROVIDER_URL="https://idp/idp/profile/SAML2/SOAP/ECP"
export OS_USERNAME="kb"
export OS_PASSWORD="r00tme"
export OS_AUTH_URL="http://keystone:5000/v3"
export OS_PROTOCOL="saml2"
