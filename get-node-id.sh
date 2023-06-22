#!/bin/bash
path="juneogo/.juneogo/config.json"
folderName=""

# Check if the line "http-tls-cert-file" exist in the file
while IFS= read -r line; do
    if [[ "$line" == *"/live/"*"/fullchain.pem"* ]]; then
        folderName="${line##*/live/}"
        folderName="${folderName%%/fullchain.pem*}"
        break
    fi
done < <( grep -Eo '/live/[^"]*' juneogo/.juneogo/config.json )
if [ -n "$folderName" ]; then
    curl -X POST --data '{
        "jsonrpc":"2.0",
        "id"     :1,
        "method" :"info.getNodeID"
    }' -H 'content-type:application/json;' https://$folderName:9650/ext/info
else
    curl -X POST --data '{
        "jsonrpc":"2.0",
        "id"     :1,
        "method" :"info.getNodeID"
    }' -H 'content-type:application/json;' http://192.168.10.2:9650/ext/info
fi


