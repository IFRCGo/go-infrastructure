#!/bin/bash

# close port 22, disable ssh
GO_NSG="dsgoNSG"
az network nsg rule delete \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $GO_NSG \
  --name 'ssh'
