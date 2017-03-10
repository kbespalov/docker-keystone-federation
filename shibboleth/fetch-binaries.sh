#!/bin/bash

SHIBBOLETH_VER=3.2.1
JETTY_VER=9.3.9.v20160517
JETTY_BASE_VER=9.3.0

IDP=shibboleth-identity-provider-$SHIBBOLETH_VER
IDP_JETTY_BASE=idp-jetty-base-$JETTY_BASE_VER
JETTY=jetty-distribution-$JETTY_VER

dists_urls=(
  http://shibboleth.net/downloads/identity-provider/$SHIBBOLETH_VER/$IDP.tar.gz
  https://build.shibboleth.net/nexus/content/repositories/releases/net/shibboleth/idp/idp-jetty-base/$JETTY_BASE_VER/$IDP_JETTY_BASE.tar.gz
  https://build.shibboleth.net/nexus/content/repositories/thirdparty/org/eclipse/jetty/jetty-distribution/$JETTY_VER/$JETTY.tar.gz
)

echo "[1] Downloading jetty and shibboleth"
echo ${dists_urls[@]} | xargs -n1 -P 4 wget -q

echo "[2] Unpacking binaries to /dists/jetty and /dists/idp"
for f in `find -name "*.tar.gz"`; do tar xf $f && rm $f; done
rm -rdf ./$IDP/embedded/jetty-base
mv ./jetty-base ./$IDP/embedded/
mv $IDP idp && mv ./$JETTY ./jetty
