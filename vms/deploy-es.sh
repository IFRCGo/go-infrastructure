#!/bin/bash

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

mkdir -p .tmp
az storage blob download \
  --container-name dsgoapikey \
  --name api.pub \
  --file .tmp/key


###################################################################
############################ ES ###################################
###################################################################


# Create a public IP to attach to the Elasticsearch VM
ES_IP_NAME="dsgoesPublicIP"
ES_DNS="dsgoes"
az network public-ip create \
  --name $ES_IP_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --allocation-method Static \
  --dns-name $ES_DNS \
  --tags "ds-project=ifrcgo-infrastructure"


VNET_NAME="dsgoVnet"
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --name $VNET_NAME \
  --address-prefix "192.168.0.0/16" \
  --tags "ds-project=ifrcgo-infrastructure"


# Create an elasticsearch subnet
# and associate it with the virtual network
ES_SUBNET="dsgoelasticsubnet"
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $ES_SUBNET \
  --address-prefix "192.168.2.0/24"


# Create the NSG
GO_NSG="dsgoNSG"
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --location $REGION \
  --name $GO_NSG \
  --tags "ds-project=ifrcgo-infrastructure"


# open port 9200 for HTTP traffic
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $GO_NSG \
  --name 'AllowESHttp' \
  --access allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 300 \
  --source-address-prefix "Internet" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 9200


ES_NIC="dsgoesPublicVMNIC"
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
ES_NAME="dsgoes"
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
