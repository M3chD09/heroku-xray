#!/bin/sh

WS_PATH=${WS_PATH:-/}
BLOCK_CN=${BLOCK_CN:-true}

cat > /usr/local/etc/xray/config.json<<EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": "$PORT",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "$WS_PATH"
                }
            }
        }
    ],
    "outbounds": [
        {
            "tag": "direct",
            "protocol": "freedom",
            "settings": {}
        },
        {
            "tag": "blocked",
            "protocol": "blackhole",
            "settings": {}
        }
    ],
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "blocked"
            }
EOF
if $BLOCK_CN = true; then
    cat >> /usr/local/etc/xray/config.json<<EOF
            ,{
                "type": "field",
                "domain": [
                    "geosite:cn"
                ],
                "outboundTag": "blocked"
            },
            {
                "type": "field",
                "ip": [
                    "geoip:cn"
                ],
                "outboundTag": "blocked"
            }
EOF
fi
cat >> /usr/local/etc/xray/config.json<<EOF
        ]
    }
}
EOF

/usr/local/bin/xray -config /usr/local/etc/xray/config.json
