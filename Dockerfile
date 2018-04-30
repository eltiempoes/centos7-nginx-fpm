FROM centos:7
ENV REFRESHED_AT 2018-03-08
LABEL maintainer "it@eltiempo.es"
LABEL version "1.1.1"
LABEL description "Image with NGINX and PHP-FPM"
ENV container docker

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install epel-release yum-utils && \
    yum -y --setopt=tsflags=nodocs install net-tools vim && \
    yum -y --setopt=tsflags=nodocs install php71w php71w-cli php71w-fpm php71w-gd php71w-mbstring php71w-mysqlnd php71w-opcache php71w-pdo php71w-xml php71w-pecl-xdebug php71w-imap php71w-tidy php71w-xmlrpc php71w-soap php71w-mcrypt php71w-intl && \
    yum clean all

RUN yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo && \
	yum -y --setopt=tsflags=nodocs install openresty openresty-resty

RUN groupadd --gid 998 nginx && \
    adduser --system --no-create-home -u 999 -g 998 -s /sbin/nologin nginx

RUN groupadd --gid 1000 cli-user && \
    adduser -u 1000 -g 1000 cli-user && \
    usermod -a -G cli-user nginx    

RUN sed -i -e 's/apache/nginx/g' /etc/php-fpm.d/www.conf
RUN sed -ri 's/^(max_execution_time = )[0-9]+(.*)$/\1300\2/' /etc/php.ini
RUN sed -ri 's/^(memory_limit = )[0-9]+(M.*)$/\1 512\2/' /etc/php.ini
RUN sed -ri 's/^(upload_max_filesize = )[0-9]+(M.*)$/\1 300\2/' /etc/php.ini
RUN sed -ri 's/^(post_max_size = )[0-9]+(M.*)$/\1 350\2/' /etc/php.ini
RUN sed  -i '1i user  nginx;' /usr/local/openresty/nginx/conf/nginx.conf

RUN mkdir -p /var/log/nginx && \
    mkdir -p /var/lib/php && \
    mkdir -p /etc/nginx/conf.d && \
    chown nginx.nginx /var/log/nginx && \
    chown -R nginx.nginx /var/lib/php && \
    ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log    

COPY zlib.lua /usr/local/openresty/lualib
COPY zlib_h.lua /usr/local/openresty/lualib
COPY nginx.conf.default /usr/local/openresty/nginx/conf/nginx.conf

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod -v +x /usr/local/bin/startup.sh

EXPOSE 80 443 8080

CMD ["/usr/local/bin/startup.sh"]