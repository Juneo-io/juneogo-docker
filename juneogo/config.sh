#!/bin/bash
echo "System time and date:"
timedatectl

if [ ! -d "./.juneogo/configs" ]; then
  mkdir -p ./.juneogo/configs
fi

# Check if the folder /.juneogo./configs/chains exists, if not create the chains folder
if [ ! -d "./.juneogo/configs/chains" ]; then
  mkdir -p ./.juneogo/configs/chains
fi

if [ ! -d "./.juneogo/chainData" ]; then
  mkdir -p ./.juneogo/chainData
fi

# Check if .juneogo/config.json exists, if not create the file with the default configuration
if [ ! -f ".juneogo/config.json" ]; then
  # Create the file .juneogo/config.json
  touch .juneogo/config.json
  # Copy .juneogo/config.exemple.json to .juneogo/config.json
  cp .juneogo/config.exemple.json .juneogo/config.json
fi

# Check if the file .juneogo/staking/staker.crt exists
if [ -f ".juneogo/staking/staker.crt" ]; then
  # Check if the lines "staking-tls-cert-file" and "staking-tls-key-file" exist in the file .juneogo/config.json
  if grep -q '"staking-tls-cert-file"' .juneogo/config.json && grep -q '"staking-tls-key-file"' .juneogo/config.json; then
    # Do nothing
    echo "Lines already present in the file"
    :
  else
    # Add missing lines to the file .juneogo/config.json
     echo "add line into the file"
     sed -i '1r config.txt' .juneogo/config.json
            sed -i '1a\' .juneogo/config.json

    
  fi
else
  # Remove the lines "staking-tls-cert-file" and "staking-tls-key-file" from the file .juneogo/config.json
  sed -i '/^\s*"staking-tls-cert-file"/d' .juneogo/config.json
  sed -i '/^\s*"staking-tls-key-file"/d' .juneogo/config.json
fi

# Add public IP into the config file

# Path to your JSON file
config_json=".juneogo/config.json"

# Fetch the new public IP address using ipinfo.io
public_ip=$(curl -s http://ipinfo.io | jq -r '.ip')

# Update or add the public IP in the existing JSON file
jq --arg ip "$public_ip" 'if has("public-ip") then .["public-ip"]=$ip else . + {"public-ip":$ip} end' "$config_json" > temp.json && mv temp.json "$config_json"