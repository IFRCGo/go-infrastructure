#!/bin/bash

export GIT_BRANCH=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
./parameters/create-parameters -b $GIT_BRANCH -p dev

az login --username $AZURE_USER --password $AZURE_PASS
az group deployment validate \
    --mode Incremental \
    --resource-group IFRCGOLabs \
    --template-file azuredeploy.template.json \
    --parameters @.tmp/params.json
