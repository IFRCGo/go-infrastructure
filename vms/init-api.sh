#!/bin/bash

if [[ ($1 = "") ]] ; then
   echo "Please enter docker image"
   exit 1
fi

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

FQDN="$(az network public-ip show -g $RESOURCE_GROUP -n $API_IP_NAME --query "{ fqdn: dnsSettings.fqdn }" | jq -r '.fqdn')"
export API_FQDN=$FQDN

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api \
  --file .tmp/key

chmod 600 .tmp/key

IP="$(az vm list-ip-addresses --resource-group $RESOURCE_GROUP --name $API_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)"

echo "DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY" >> .tmp/env
echo "DJANGO_DB_HOST=$DJANGO_DB_HOST" >> .tmp/env
echo "DJANGO_DB_PORT=$DJANGO_DB_PORT" >> .tmp/env
echo "DJANGO_DB_NAME=$DJANGO_DB_NAME" >> .tmp/env
echo "DJANGO_DB_USER=$DJANGO_DB_USER" >> .tmp/env
echo "DJANGO_DB_PASS=$DJANGO_DB_PASS" >> .tmp/env
echo "GO_FTPHOST=$GO_FTPHOST" >> .tmp/env
echo "GO_FTPUSER=$GO_FTPUSER" >> .tmp/env
echo "GO_FTPPASS=$GO_FTPPASS" >> .tmp/env
echo "GO_DBPASS=$GO_DBPASS" >> .tmp/env
echo "APPEALS_USER=$APPEALS_USER" >> .tmp/env
echo "APPEALS_PASS=$APPEALS_PASS" >> .tmp/env
echo "ES_HOST=$ES_HOST" >> .tmp/env
echo "EMAIL_HOST=$EMAIL_HOST" >> .tmp/env
echo "EMAIL_PORT=$EMAIL_PORT" >> .tmp/env
echo "EMAIL_USER=$EMAIL_USER" >> .tmp/env
echo "EMAIL_PASS=$EMAIL_PASS" >> .tmp/env
echo "API_FQDN=$FQDN" >> .tmp/env
echo "BULK_IMPORT=1" >> .tmp/env

scp -i .tmp/key .tmp/env $API_ADMIN@$IP:.env
scp -i .tmp/key certificates/ifrcgoapi.crt $API_ADMIN@$IP:.ifrcgoapi.crt
scp -i .tmp/key certificates/ifrcgoapi.key $API_ADMIN@$IP:.ifrcgoapi.key
ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP cat $(pwd)/.ifrcgoapi.crt && docker run -d \
  -v $(pwd)/.ifrcgoapi.crt:/etc/ssl/server.pem \
  -v $(pwd)/.ifrcgoapi.key:/etc/ssl/serverkey.pem \
  -p 80:80 -p 443:443 \
  --env-file .env \
  -t $1

rm .tmp/env
rm .tmp/key
