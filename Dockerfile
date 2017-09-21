FROM centos:7
LABEL maintainer "it@eltiempo.es"
LABEL version "1.1"
LABEL description "Image with NGINX and PHP-FPM"
ENV container docker

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install epel-release && \
    yum -y --setopt=tsflags=nodocs install nginx net-tools vim && \
    yum -y --setopt=tsflags=nodocs install php71w php71w-cli php71w-fpm php71w-gd php71w-mbstring php71w-mysqlnd php71w-opcache php71w-pdo php71w-xml php71w-pecl-xdebug php71w-imap php71w-tidy php71w-xmlrpc php71w-soap php71w-pecl-mongodb && \
    yum clean all

RUN sed -i -e 's/apache/nginx/g' /etc/php-fpm.d/www.conf
RUN sed -ri 's/^(max_execution_time = )[0-9]+(.*)$/\1120\2/' /etc/php.ini
RUN sed -ri 's/^(memory_limit = )[0-9]+(M.*)$/\1 256\2/' /etc/php.ini

RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log
RUN chgrp -R nginx /var/lib/php

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod -v +x /usr/local/bin/startup.sh

EXPOSE 80

CMD ["/usr/local/bin/startup.sh"]