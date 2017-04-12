#!/bin/bash

/usr/sbin/php-fpm --daemonize --fpm-config /etc/php-fpm.conf
nginx -g 'daemon off;'