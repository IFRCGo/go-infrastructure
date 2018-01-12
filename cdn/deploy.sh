#!/bin/bash


FQDN="$(az network public-ip show -g $RESOURCE_GROUP -n $API_IP_NAME --query "{ fqdn: dnsSettings.fqdn }" | jq -r '.fqdn')"


az cdn profile create --name $CDN_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --sku Standard_Verizon


az cdn endpoint create --name $CDN_API_ENDPOINT_NAME \
  --query-string-caching UseQueryString \
  --origin $FQDN 80 443 \
  --profile-name $CDN_NAME \
  --resource-group $RESOURCE_GROUP
