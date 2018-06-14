#!/bin/bash

# close port 22, disable ssh
az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $GO_NSG \
  --name 'ssh'
