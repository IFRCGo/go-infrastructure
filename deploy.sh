#!/bin/bash
# NOTE: Don't change the deployment mode.
# It can potentially wipe out everything else in the resource group.

# Create the parameters file, and append the git branch to the end of it
export GIT_BRANCH=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
./parameters/create-parameters -b $GIT_BRANCH -p dev

source ./.azure-credentials && az login --username $AZURE_USER --password $AZURE_PASS
az group deployment create \
    --debug \
    --mode Incremental \
    --name dsGoInfrastructure \
    --resource-group IFRCGOLabs \
    --template-file azuredeploy.template.json \
    --parameters @.tmp/params.json
