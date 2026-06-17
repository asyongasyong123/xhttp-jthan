FROM alpine:3.19 AS xray-bin
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /tmp
RUN curl -fL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
 && unzip xray.zip xray \
 && chmod +x xray \
 && mv xray /usr/local/bin/xray \
 && rm -rf /tmp/*

FROM openresty/openresty:alpine
RUN apk add --no-cache ca-certificates

COPY --from=xray-bin /usr/local/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

COPY config.json /etc/xray.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8080

CMD ["/bin/sh", "-c", "set -e; xray run -c /etc/xray.json & sleep 5; openresty -g 'daemon off;'"]
