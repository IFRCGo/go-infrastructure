#!/bin/bash
# NOTE: Don't change the deployment mode.
# It can potentially wipe out everything else in the resource group.
source ./.azure-credentials && az login --username $AZURE_USER --password $AZURE_PASS
az group deployment create \
    --debug \
    --mode Incremental \
    --name dsGoDb \
    --resource-group IFRCGOLabs \
    --template-file postgresql/azuredeploy.json \
    --parameters @postgresql/dev.parameters.json
