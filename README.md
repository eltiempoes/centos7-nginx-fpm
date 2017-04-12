# Docker CentOS 7 image with NGINX and PHP-FPM

This Docker image is intended to be used as a general NGINX web server with PHP-FPM.

## How to use it to serve static files

The default server is configured to serve static files from `/usr/share/nginx/html` so the easiest way of using the image is, for example:

`docker run -d -v /home/user/samples/html:/usr/share/nginx/html -p 8080:80 eltiempoes/centos7-nginx-fpm`

## How to use it to serve php files

Instead of using the default nginx configuration you can pass your own configuration. The image nginx configuration is prepared to load all configuration files from `/etc/nginx/conf.d`.

So, imagine you have a config file called `local.conf` into `/home/user/samples` and the php application you want to use is installed in `/home/user/webapp`:

```
server {
    listen       80;
    server_name  local.localdomain;

    charset utf-8;
    

    location / {
        root   /webapp/public;
        index  index.php index.html index.htm;
        try_files $uri $uri/ /index.php?$query_string;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /webapp/public$fastcgi_script_name;
        include        fastcgi_params;
    }

}
```
the way to start the PHP application is:

```
docker run -d -v /home/user/samples/webapp:/webapp -v /home/user/samples/local.conf:/etc/nginx/conf.d/local.conf -p 8080:80 eltiempoes/centos7-nginx-fpm
```
