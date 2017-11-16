#!/bin/bash

az login --username $AZURE_USER --password $AZURE_PASS

storagename=dsgoproxystorage
appname=dsgoproxyapp
region=westeurope
resourcegroup=IFRCGOLabs

az storage account create \
  --name $storagename \
  --location $region \
  --resource-group $resourcegroup \
  --sku Standard_LRS

az functionapp create \
  --name $appname \
  --storage-account $storagename \
  --consumption-plan-location $region \
  --resource-group $resourcegroup

az functionapp deployment source config \
  --name $appname \
  --repo-url https://github.com/developmentseed/go-functions \
  --branch master \
  --resource-group $resourcegroup
