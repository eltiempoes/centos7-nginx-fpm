#!/bin/bash

/usr/sbin/php-fpm --daemonize --fpm-config /etc/php-fpm.conf

PATH=/usr/local/openresty/nginx/sbin:$PATH
export PATH

nginx -g 'daemon off;'