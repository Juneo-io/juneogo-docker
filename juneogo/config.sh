#!/bin/bash

# Vérifie si le fichier .juneogo/staking/staker.crt existe
if [ -f ".juneogo/staking/staker.crt" ]; then
  # Vérifie si les lignes "db-dir", "log-dir", "staking-tls-cert-file" et "staking-tls-key-file" existent dans le fichier .juneogo/config.json
  if grep -q '"staking-tls-cert-file"' .juneogo/config.json && grep -q '"staking-tls-key-file"' .juneogo/config.json; then
    # Ne fait rien
    echo "Lines already present in the file"
    :
  else
    # Ajoute les lignes manquantes au fichier .juneogo/config.json
     echo "add line into the file"
     sed -i '1r config.txt' .juneogo/config.json
            sed -i '1a\' .juneogo/config.json

    
  fi
else
  # Supprime les lignes "db-dir", "log-dir", "staking-tls-cert-file" et "staking-tls-key-file" du fichier .juneogo/config.json
  sed -i '/^\s*"staking-tls-cert-file"/d' .juneogo/config.json
  sed -i '/^\s*"staking-tls-key-file"/d' .juneogo/config.json
fi
