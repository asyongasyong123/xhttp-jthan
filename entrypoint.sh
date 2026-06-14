#!/bin/sh
set -e
PORT="${PORT:-8080}"
sed -i.bak "s|listen 8080 ssl http2;|listen 0.0.0.0:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
sed -i.bak "s|listen \[::\]:8080 ssl http2;|listen [::]:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
rm -f /usr/local/openresty/nginx/conf/nginx.conf.bak
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /tmp/server.key -out /tmp/server.crt -subj "/CN=localhost"
sed -i "s|ssl_certificate /dev/null;|ssl_certificate /tmp/server.crt;|g" /usr/local/openresty/nginx/conf/nginx.conf
sed -i "s|ssl_certificate_key /dev/null;|ssl_certificate_key /tmp/server.key;|g" /usr/local/openresty/nginx/conf/nginx.conf
xray run -c /etc/xray.json &
exec /usr/local/openresty/bin/openresty -g "daemon off;"
