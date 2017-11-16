#!/bin/bash

storagename=dsgoproxystorage
appname=dsgoproxyapp
resourcegroup=IFRCGOLabs

az resource tag \
  --tags ds-project=ifrcgo-infrastructure \
  -g $resourcegroup \
  -n $storagename \
  --resource-type "Microsoft.Storage/storageAccounts"

az resource tag \
  --tags ds-project=ifrcgo-infrastructure \
  -g $resourcegroup \
  -n $appname \
  --resource-type "Microsoft.Web/sites"
