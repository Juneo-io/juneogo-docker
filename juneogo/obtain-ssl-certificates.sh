#!/bin/bash

# Obtain SSL certificates from Let's Encrypt

# Set the domain name
domain_name=$1
email_address=$2

# Check if a domain name was specified
if [ -z "${domain_name}" ]; then
  # If no domain name was specified, remove the TLS options from the juneogo config file
  echo "No domain name specified. Remove config line in config.json"
  sed -i '/http-tls-enabled/d' .juneogo/config.json
  sed -i '/http-tls-cert-file/d' .juneogo/config.json
  sed -i '/http-tls-key-file/d' .juneogo/config.json
else
  # Check if an email address was specified
  if [ -z "${email_address}" ]; then
    echo "No email address specified. Please specify an email address using the --email option."
  else
    # If a domain name was specified, check if a certificate already exists
    if [ ! -f "/etc/letsencrypt/live/${domain_name}/cert.pem" ]; then
        # If no certificate exists, obtain a new one
        certbot certonly --standalone --agree-tos --preferred-challenges http-01 --email ${email_address} -d ${domain_name}
        if [ $? -eq 0 ]; then
        # If certificate generation succeeded, update the TLS options in the juneogo config file
        echo "Success create certificat"
        sed -i 's/http-tls-enabled.*/http-tls-enabled": "true",/' .juneogo/config.json
        sed -i "s~http-tls-cert-file.*~http-tls-cert-file\": \"/etc/letsencrypt/live/${domain_name}/fullchain.pem\",~" .juneogo/config.json
        sed -i "s~http-tls-key-file.*~http-tls-key-file\": \"/etc/letsencrypt/live/${domain_name}/privkey.pem\",~" .juneogo/config.json
        else
        
        # If certificate generation failed, remove the TLS options from the juneogo config file
        echo "Error when creating certificat"
        sed -i '/http-tls-enabled/d' .juneogo/config.json
        sed -i '/http-tls-cert-file/d' .juneogo/config.json
        sed -i '/http-tls-key-file/d' .juneogo/config.json
        fi
    else
        # If a certificate already exists, do nothing
        echo "A certificate for ${domain_name} already exists. Skipping certificate generation."
        if grep -q 'http-tls-enabled' .juneogo/config.json; then
            echo "http-tls-enabled option already present"
        else
            # Add the http-tls-enabled option
            sed -i 's/http-tls-enabled.*/http-tls-enabled": "true",/' .juneogo/config.json
        fi

        if grep -q 'http-tls-cert-file' .juneogo/config.json; then
            echo "http-tls-cert-file option already present"
        else
            # Add the http-tls-cert-file option
            echo "add"
            sed -i '1r http-tls-enabled.txt' .juneogo/config.json
            sed -i '1a\' .juneogo/config.json
            sed -i '1r http-tls-cert-file.txt' .juneogo/config.json
            sed -i '1a\' .juneogo/config.json
            sed -i "s~http-tls-cert-file.*~http-tls-cert-file\": \"/etc/letsencrypt/live/${domain_name}/fullchain.pem\",~" .juneogo/config.json
        fi

        if grep -q 'http-tls-key-file' .juneogo/config.json; then
            echo "http-tls-key-file option already present"
        else
            # Add the http-tls-key-file option
            sed -i '1r http-tls-key-file.txt' .juneogo/config.json
            sed -i '1a\' .juneogo/config.json
            sed -i "s~http-tls-key-file.*~http-tls-key-file\": \"/etc/letsencrypt/live/${domain_name}/privkey.pem\",~" .juneogo/config.json
        fi
    fi
  fi
fi