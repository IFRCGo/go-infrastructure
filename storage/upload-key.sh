#!/bin/bash

if [[ $1 = "" ]] ; then
   echo "Please include path to key, ie:"
   echo "./upload-key ~/path/to/key"
   exit 1
fi

if [[ $AZURE_STORAGE_CONNECTION_STRING = "" ]]; then
   echo "Azure storage connection string not found"
   echo "Run ./deploy.sh first"
   exit 1
fi

echo "Uploading private key"
echo "$1"
az storage blob upload \
   --file "$1" \
   --container-name "$KEY_CONTAINER" \
   --name api

echo "Uploading public key"
echo "$1.pub"
az storage blob upload \
   --file "$1.pub" \
   --container-name "$KEY_CONTAINER" \
   --name "api.pub"
