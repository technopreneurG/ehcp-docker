## By: GirishN

# A monolith Dockerfile, with all the stuff needed by EHCP

FROM ubuntu:14.04

USER root

RUN apt-get update && apt-get upgrade -y

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get update && apt-get install -y wget tar php5

RUN echo 'mysql-server-5.5 mysql-server/root_password password 1234' | debconf-set-selections \
        && echo 'mysql-server-5.5 mysql-server/root_password_again password 1234' | debconf-set-selections \
        && echo 'mariadb-server-5.5 mysql-server/root_password        password 1234' | debconf-set-selections \
        && echo 'mariadb-server-5.5 mysql-server/root_password_again password 1234' | debconf-set-selections \
        && echo 'mysql-server mysql-server/root_password password 1234' | debconf-set-selections \
        && echo 'mysql-server mysql-server/root_password_again password 1234' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/app-password-confirm password 1234' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/mysql/admin-pass password 1234' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/mysql/app-pass password 1234' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections \
        && echo 'phpmyadmin phpmyadmin/dbconfig-reinstall boolean true' | debconf-set-selections \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-remove --allow-unauthenticated \
        python-software-properties \
        php5 \
        php5-mysqlnd \
        php5-cli \
        sudo \
        wget \
        aptitude \
        apache2-utils \
        debconf-utils \
        mariadb-server \
        mariadb-client \
        php5-mysqlnd \
        unrar \
        rar \
        unzip \
        zip \
        openssh-server \
        python-mysqldb \
        python-cherrypy3 \
        apache2 \
        bind9 \
        php5-gd \
        curl \
        phpmyadmin \
        postfix \
        postfix-mysql \
        courier-authdaemon \
        courier-pop \
        courier-pop-ssl \
        courier-imap \
        courier-imap-ssl \
        libsasl2-modules \
        libsasl2-modules-sql \
        sasl2-bin \
        libpam-mysql \
        openssl \
        fail2ban \
        vsftpd \
        nginx \
        php5-fpm \
        php5-cgi

RUN service courier-authdaemon start

RUN echo 'roundcube-core roundcube/password-confirm password 1234' | debconf-set-selections \
        && echo 'roundcube-core roundcube/mysql/admin-pass password 1234' | debconf-set-selections \
        && echo 'roundcube-core roundcube/mysql/app-pass password 1234' | debconf-set-selections \
        && echo 'roundcube-core roundcube/app-password-confirm password 1234' | debconf-set-selections \
        && echo 'roundcube-core roundcube/database-type select mysql' | debconf-set-selections \
        && echo 'roundcube-core roundcube/dbconfig-install boolean true' | debconf-set-selections \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-remove --allow-unauthenticated \
        courier-authlib-mysql \
        roundcube \
        roundcube-mysql \
        roundcube-plugins \
        roundcube-plugins-extra


RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-remove --allow-unauthenticated \
        auth-client-config \
        ldap-auth-client \
        ldap-auth-config \
        libnss-ldap

WORKDIR /

RUN wget -O ehcp.tgz https://github.com/technopreneurG/EHCP_PF/archive/v0.1-0.37.4.b.tar.gz
RUN tar -zxf ehcp.tgz
RUN mv EHCP_PF-* ehcp

#Alternate download
#RUN wget -O ehcp.tgz www.ehcp.net/ehcp_latest.tgz
#RUN tar -zxvf ehcp.tgz

#Another Alternate: put your ehcp code into ./ehcp_src
#ADD ./ehcp_src /ehcp
WORKDIR /ehcp

ARG ADMIN_EMAIL

RUN cd /ehcp &&  ./install.sh unattended

EXPOSE 21 53 80 587 953 3306 9000

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["init"]

