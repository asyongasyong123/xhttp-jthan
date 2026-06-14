FROM alpine:3.20 AS builder
WORKDIR /app
RUN apk add --no-cache curl unzip ca-certificates
RUN curl -fL --retry 3 https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip && unzip xray.zip xray && chmod +x xray && mv xray /usr/local/bin/ && rm -f xray.zip

FROM openresty/openresty:1.25.3.1-alpine
RUN apk add --no-cache ca-certificates bash tzdata openssl
COPY --from=builder /usr/local/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray.json
RUN chmod +x /usr/local/bin/xray
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
