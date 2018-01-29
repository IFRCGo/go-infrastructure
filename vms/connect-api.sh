#!/bin/bash

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api \
  --file .tmp/key

chmod 600 .tmp/key

IP="$(az vm list-ip-addresses --resource-group $RESOURCE_GROUP --name $API_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)"

ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP

rm .tmp/key
