FROM teddysun/xray:latest AS xray
FROM openresty/openresty:alpine

COPY --from=xray /usr/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

COPY config.json /etc/xray.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8080

CMD ["sh", "-c", "xray run -c /etc/xray.json & sleep 2 && openresty -g 'daemon off;'"]
