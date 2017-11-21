#!/bin/bash

az resource tag \
  --tags ds-project=ifrcgo-infrastructure \
  -g $RESOURCE_GROUP \
  -n $PROXY_APP_STORAGE \
  --resource-type "Microsoft.Storage/storageAccounts"

az resource tag \
  --tags ds-project=ifrcgo-infrastructure \
  -g $RESOURCE_GROUP \
  -n $PROXY_APP_NAME \
  --resource-type "Microsoft.Web/sites"
