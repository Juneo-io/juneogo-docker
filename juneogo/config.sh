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
