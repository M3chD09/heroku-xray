FROM alpine:latest

LABEL maintainer="m3chd09 <m3chd09@protonmail.com>"

ARG XRAY_VERSION=v1.5.5

COPY run.sh /run.sh
RUN apk add --no-cache unzip wget \
    && wget "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" -O /tmp/Xray-linux-64.zip \
    && wget "https://github.com/v2fly/geoip/releases/latest/download/geoip.dat" -O /tmp/geoip.dat \
    && wget "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat" -O /tmp/dlc.dat \
    && mkdir -p /tmp/xray \
    && mkdir -p /usr/local/share/xray \
    && mkdir -p /usr/local/etc/xray \
    && unzip /tmp/Xray-linux-64.zip -d /tmp/xray \
    && install -m 0755 /tmp/xray/xray /usr/local/bin/xray  \
    && install -m 0644 /tmp/geoip.dat /usr/local/share/xray/geoip.dat \
    && install -m 0644 /tmp/dlc.dat /usr/local/share/xray/geosite.dat \
    && rm -rf /tmp/Xray-linux-64.zip /tmp/xray /tmp/geoip.dat /tmp/dlc.dat \
    && chmod +x /run.sh

CMD /run.sh
