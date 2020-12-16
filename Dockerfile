FROM centos:7

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y supervisor centos-release-scl subscription-manager wget && \
    yum install -y httpd && \
    yum clean all
RUN yum install openssl -y

WORKDIR /opt
RUN wget https://downloads.jboss.org/keycloak/4.8.3.Final/keycloak-4.8.3.Final.tar.gz && \
    tar xzf keycloak-4.8.3.Final.tar.gz && \
    groupadd -r keycloak && \
    useradd -m -d /var/lib/keycloak -s /sbin/nologin -r -g keycloak keycloak && \
    chown keycloak: -R keycloak-4.8.3.Final

WORKDIR /opt/keycloak-4.8.3.Final
COPY startup.sh /opt/keycloak-4.8.3.Final/startup.sh
RUN yum -y install java-1.8.0-openjdk-devel

COPY vhost.conf /etc/httpd/conf.d/vhost.conf
COPY supervisord.conf /etc/supervisord.conf

CMD ["/bin/sh", "-c", "/usr/bin/supervisord -c /etc/supervisord.conf"]