#!/bin/bash

if [[ $1 = "" ]] ; then
   echo "Please include path to certificate, ie:"
   echo "./upload-key ~/path/to/certificate"
   exit 1
fi

if [[ $AZURE_STORAGE_CONNECTION_STRING = "" ]]; then
   echo "Azure storage connection string not found"
   echo "Run ./deploy.sh first"
   exit 1
fi

echo "Uploading certificate key"
echo "$1"
az storage blob upload \
   --file "$1.crt" \
   --container-name "$KEY_CONTAINER" \
   --name "ifrcgoapi.crt"

echo "Uploading key"
echo "$1.pub"
az storage blob upload \
   --file "$1.key" \
   --container-name "$KEY_CONTAINER" \
   --name "ifrcgoapi.key"
