#!/bin/sh 

# generate/modify xray-core json config 
# extract desired variables using jq 

name=$(jq -r '.name' conf.json)
email=$(jq -r '.email' conf.json)
port=$(jq -r '.port' conf.json)
sni=$(jq -r '.sni' conf.json)
path=$(jq -r '.path' conf.json)
server=$(jq -r '.server' conf.json)
keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
json=$(curl -s https://raw.githubusercontent.com/SasukeFreestyle/XTLS-Iran-Reality/main/config.json)
url="vless://$uuid@$server:$port?type=http&security=reality&encryption=none&pbk=$pub&fp=chrome&path=$path&sni=$sni&sid=$shortId#$name"

newJson=$(echo $json | jq  \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    --arg port "$port" \
    --arg sni "$sni" \
    --arg path "$path" \
     '.inbounds[0].port = '$port' |
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.dest = $sni + ":443" |
     .inbounds[0].streamSettings.realitySettings.serverNames += ["cdn.'$sni'", "'$sni'"] |
     .inbounds[0].streamSettings.realitySettings.privateKey = $pk |
     .inbounds[0].streamSettings.realitySettings.shortIds = ["'$shortId'"]')

echo $newJson | tee /etc/xray/config.json >/dev/null
echo "$url" 
echo "$url" | nc termbin.com 9999
#qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"
curl -s bashupload.com -T qr.png