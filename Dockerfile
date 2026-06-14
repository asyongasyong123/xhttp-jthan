FROM alpine:3.20
RUN apk add --no-cache ca-certificates bash curl
RUN curl -fL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip && \
    unzip xray.zip xray && chmod +x xray && mv xray /usr/local/bin/ && rm -f xray.zip
COPY config.json /etc/xray.json
ENV PORT=8080
EXPOSE 8080
CMD ["xray", "run", "-c", "/etc/xray.json"]
