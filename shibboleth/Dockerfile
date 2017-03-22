FROM azul/zulu-openjdk:8

EXPOSE 443 8443 80

RUN mkdir /dists
WORKDIR dists

# fetch jetty and shibboleth
RUN  apt-get install -qqy wget vim
ADD ./fetch-binaries.sh fetch-binaries.sh
RUN ./fetch-binaries.sh

# set environment variables
ENV JAVA_HOME=/usr/lib/jvm/zulu-8-amd64/
ENV JRE_HOME=/usr/lib/jvm/zulu-8-amd64/jre
ENV JETTY_HOME=/dists/jetty

COPY ./configs/properties/* /dists/

# build & deploy shibboleth
RUN ./idp/bin/install.sh -propertyfile install.properties
RUN ./idp/bin/ant.sh -f /opt/shibboleth-idp/bin/ant-jetty.xml -propertyfile install.properties

# replace xmlbeans: attribute-map, access-control, etc
COPY ./configs/beans/* /opt/shibboleth-idp/conf/

# replace some configs to enable & configure ECP SAML2
COPY ./configs/ecp/* /opt/shibboleth-idp/ecp/
RUN mv /opt/shibboleth-idp/ecp/web.xml /opt/shibboleth-idp/webapp/WEB-INF/web.xml && \
    mv /opt/shibboleth-idp/ecp/jetty-http.xml /opt/shibboleth-idp/jetty-base/etc/jetty-http.xml && \
    mv /opt/shibboleth-idp/ecp/login.conf /opt/shibboleth-idp/jetty-base/etc/login.conf && \
    echo "--module=jaas" >> /opt/shibboleth-idp/jetty-base/start.ini && \
    sed -i '/copyWebInf/a<Get name="securityHandler"><Set name="realmName">ShibUserPassAuth</Set></Get>' /opt/shibboleth-idp/jetty-base/webapps/idp.xml

# enable debbugging
RUN sed -i "s/\"idp.loglevel.idp\" value=\"INFO\"/\"idp.loglevel.idp\" value=\"DEBUG\"/g" /opt/shibboleth-idp/conf/logback.xml

WORKDIR /opt/shibboleth-idp/jetty-base

# CMD ["java",\
#     "-Didp.home=/opt/shibboleth-idp", \
#     "-Djetty.base=/opt/shibboleth-idp/jetty-base",\
#     "-Djetty.logs=/opt/shibboleth-idp/jetty-base/logs",\
#     "-jar", "/dists/jetty/start.jar"]
