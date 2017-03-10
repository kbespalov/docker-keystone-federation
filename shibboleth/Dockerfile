FROM azul/zulu-openjdk:8

EXPOSE 8443 80

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
# to make possible https access
#RUN iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8443

# replace xmlbeans: attribute-map, access-control, etc
COPY ./configs/beans/* /opt/shibboleth-idp/conf/
WORKDIR /opt/shibboleth-idp/jetty-base

# enable debbugging
RUN sed -i "s/\"idp.loglevel.idp\" value=\"INFO\"/\"idp.loglevel.idp\" value=\"DEBUG\"/g" /opt/shibboleth-idp/conf/logback.xml

CMD ["java",\
    "-Didp.home=/opt/shibboleth-idp", \
    "-Djetty.base=/opt/shibboleth-idp/jetty-base",\
    "-Djetty.logs=/opt/shibboleth-idp/jetty-base/logs",\
    "-jar", "/dists/jetty/start.jar"]
