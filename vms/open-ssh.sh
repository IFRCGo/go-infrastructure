#!/bin/bash

# open port 22 for SSH traffic
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $GO_NSG \
  --name 'ssh' \
  --access allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 1000 \
  --source-address-prefix "Internet" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 22
