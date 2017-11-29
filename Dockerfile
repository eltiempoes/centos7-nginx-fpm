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
    yum -y --setopt=tsflags=nodocs install php71w php71w-cli php71w-fpm php71w-gd php71w-mbstring php71w-mysqlnd php71w-opcache php71w-pdo php71w-xml php71w-pecl-xdebug php71w-imap php71w-tidy php71w-xmlrpc php71w-soap php71w-mcrypt php71w-intl && \
    yum clean all

RUN sed -i -e 's/apache/nginx/g' /etc/php-fpm.d/www.conf
RUN sed -ri 's/^(max_execution_time = )[0-9]+(.*)$/\1300\2/' /etc/php.ini
RUN sed -ri 's/^(memory_limit = )[0-9]+(M.*)$/\1 512\2/' /etc/php.ini
RUN sed -ri 's/^(upload_max_filesize = )[0-9]+(M.*)$/\1 300\2/' /etc/php.ini
RUN sed -ri 's/^(post_max_size = )[0-9]+(M.*)$/\1 350\2/' /etc/php.ini

RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /var/lib/php && \
	chgrp -R nginx /var/lib/php

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod -v +x /usr/local/bin/startup.sh

RUN groupadd --gid 1000 cli-user && \
    adduser -u 1000 -g 1000 cli-user && \
    usermod -a -G cli-user nginx

EXPOSE 80 443

CMD ["/usr/local/bin/startup.sh"]