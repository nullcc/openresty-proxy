#!/usr/bin/env bash
nginx_started=$(ps -ef | grep nginx | grep -v 'grep')

if [ -z "$nginx_started" ]; then
  # nginx is not started, start nginx
  echo 'Start Nginx...'
  # nginx -t `pwd` -c config/nginx.conf
  nginx -p `pwd` -c config/nginx.conf
else
  # nginx is started, reload nginx
  echo 'Reload Nginx...'
  # nginx -t -p `pwd` -c config/nginx.conf
  nginx -s reload -p `pwd` -c config/nginx.conf
fi
