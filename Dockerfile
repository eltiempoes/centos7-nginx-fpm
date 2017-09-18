FROM centos:7
LABEL maintainer "it@eltiempo.es"
LABEL version "1.0"
LABEL description "Image with NGINX and PHP-FPM"
ENV container docker

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install epel-release && \
    yum -y --setopt=tsflags=nodocs install nginx net-tools vim && \
    yum -y --setopt=tsflags=nodocs install php70w php70w-cli php70w-fpm php70w-gd php70w-mbstring php70w-mysqlnd php70w-opcache php70w-pdo php70w-xml php70w-pecl-xdebug php70w-imap php70w-tidy php70w-xmlrpc php70w-soap php70w-pecl-mongodb php70w-pecl-redis && \
    yum clean all

RUN sed -i -e 's/apache/nginx/g' /etc/php-fpm.d/www.conf
RUN sed -ri 's/^(max_execution_time = )[0-9]+(.*)$/\1120\2/' /etc/php.ini
RUN sed -ri 's/^(memory_limit = )[0-9]+(M.*)$/\1 256\2/' /etc/php.ini

RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod -v +x /usr/local/bin/startup.sh

EXPOSE 80

CMD ["/usr/local/bin/startup.sh"]