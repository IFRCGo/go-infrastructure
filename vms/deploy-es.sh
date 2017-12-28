#!/bin/bash

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api.pub \
  --file .tmp/key


###################################################################
############################ ES ###################################
###################################################################


# Create a public IP to attach to the Elasticsearch VM
az network public-ip create \
  --name $ES_IP_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --allocation-method Static \
  --dns-name $ES_DNS \
  --tags "ds-project=ifrcgo-infrastructure"


az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --name $VNET_NAME \
  --address-prefix "192.168.0.0/16" \
  --tags "ds-project=ifrcgo-infrastructure"


# Create an elasticsearch subnet
# and associate it with the virtual network
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $ES_SUBNET \
  --address-prefix "192.168.2.0/24"


az network nic create \
  --name $ES_NIC \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --subnet $ES_SUBNET \
  --private-ip-address 192.168.2.101 \
  --vnet-name $VNET_NAME \
  --network-security-group $GO_NSG \
  --public-ip-address $ES_IP_NAME \
  --tags "ds-project=ifrcgo-infrastructure"


# create a vm for Elasticsearch with no public ip
az vm create \
  --ssh-key-value @.tmp/key \
  --authentication-type ssh \
  --admin-username $API_ADMIN \
  --resource-group $RESOURCE_GROUP \
  --name $ES_NAME \
  --nics $ES_NIC \
  --location $REGION \
  --image UbuntuLTS \
  --storage-sku Standard_LRS \
  --tags "ds-project=ifrcgo-infrastructure"


# set the ES docker extension
az vm extension set \
  --name DockerExtension \
  --publisher Microsoft.Azure.Extensions \
  --vm-name $ES_NAME \
  --resource-group $RESOURCE_GROUP \
  --version 1.1


# remove the public key
rm .tmp/key
