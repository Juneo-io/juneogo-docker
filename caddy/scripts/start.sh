#!/bin/sh

# Check if CADDY_USER and CADDY_PASSWORD are defined
if [ -z "$CADDY_USER" ] || [ -z "$CADDY_PASSWORD" ]; then
  echo "Error: CADDY_USER and CADDY_PASSWORD must be set"
  exit 1
fi

# Install curl and jq
apk add --no-cache curl jq

while true; do
  curl -s http://ipinfo.io | jq -r '.ip' > /etc/caddy/public_ip
  sleep 3600
done &

caddy run