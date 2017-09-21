#!/bin/bash

/usr/sbin/php-fpm --daemonize --fpm-config /etc/php-fpm.conf
chgrp -R nginx /var/lib/php
nginx -g 'daemon off;'