#!/bin/bash

if [ -z ${REPO_DIR+x} ]; then
  BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  REPO_DIR=$(dirname "$BASE_DIR")
fi
FILE=$REPO_DIR/docker-compose-prod.yml
if [ -f "$FILE" ]; then
  echo -e "The location of the remotely used docker-compose-prod.yml is:\n"$(ls $FILE)
else
  echo "$FILE does not exist. (CTRL+C to finish)"; read a; exit 1
fi

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
# ADMIN_URL instead of this: CDN_HOSTNAME="$(az cdn endpoint show --name $CDN_API_ENDPOINT_NAME --profile-name $CDN_NAME --resource-group $RESOURCE_GROUP | jq -r '.hostName')"
FQDN="$(az network public-ip show -g $RESOURCE_GROUP -n $API_IP_NAME --query "{ fqdn: dnsSettings.fqdn }" | jq -r '.fqdn')"
STORAGE_KEY="$(az storage account keys list --account-name $STORAGE_NAME --resource-group $RESOURCE_GROUP | jq -r '.[0].value')"

# Take care, staging and prod blob storage differs! If you use the same script, use same names everywhere!
mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api \
  --file .tmp/key

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name "ifrcgoapi2022.crt" \
  --file .tmp/ifrcgoapi.crt

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name "ifrcgoapi.key" \
  --file .tmp/ifrcgoapi.key

chmod 600 .tmp/key

IP="$(az vm list-ip-addresses --resource-group $RESOURCE_GROUP --name $API_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)"

echo "DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY" >> .tmp/env
echo "DJANGO_DB_HOST=$DJANGO_DB_HOST" >> .tmp/env
echo "DJANGO_DB_PORT=$DJANGO_DB_PORT" >> .tmp/env
echo "DJANGO_DB_NAME=$DJANGO_DB_NAME" >> .tmp/env
echo "DJANGO_DB_USER=$DJANGO_DB_USER" >> .tmp/env
echo "DJANGO_DB_PASS=$DJANGO_DB_PASS" >> .tmp/env
echo "DJANGO_ADDITIONAL_ALLOWED_HOSTS=$DJANGO_ADDITIONAL_ALLOWED_HOSTS" >> .tmp/env
echo "GO_ENVIRONMENT=$GO_ENVIRONMENT" >> .tmp/env
echo "GO_FTPHOST=$GO_FTPHOST" >> .tmp/env
echo "GO_FTPUSER=$GO_FTPUSER" >> .tmp/env
echo "GO_FTPPASS=$GO_FTPPASS" >> .tmp/env
echo "GO_DBPASS=$GO_DBPASS" >> .tmp/env
echo "APPEALS_USER=$APPEALS_USER" >> .tmp/env
echo "APPEALS_PASS=$APPEALS_PASS" >> .tmp/env
echo "ELASTIC_SEARCH_HOST=$ELASTIC_SEARCH_HOST" >> .tmp/env
echo "EMAIL_HOST=$EMAIL_HOST" >> .tmp/env
echo "EMAIL_PORT=$EMAIL_PORT" >> .tmp/env
echo "EMAIL_USER=$EMAIL_USER" >> .tmp/env
echo "EMAIL_PASS=$EMAIL_PASS" >> .tmp/env
echo "EMAIL_API_ENDPOINT=$EMAIL_API_ENDPOINT" >> .tmp/env
echo "AZURE_STORAGE_ACCOUNT=$STORAGE_NAME" >> .tmp/env
echo "AZURE_STORAGE_KEY=$STORAGE_KEY" >> .tmp/env
echo "API_FQDN=$ADMIN_URL" >> .tmp/env
echo "FRONTEND_URL=$FRONTEND_URL" >> .tmp/env
echo "IS_WORKER=$IS_WORKER" >> .tmp/env
echo "CELERY_REDIS_URL=$CELERY_REDIS_URL" >> .tmp/env
echo "MOLNIX_API_BASE=$MOLNIX_API_BASE" >> .tmp/env
echo "MOLNIX_USERNAME=$MOLNIX_USERNAME" >> .tmp/env
echo "MOLNIX_PASSWORD=$MOLNIX_PASSWORD" >> .tmp/env
echo "MAPBOX_ACCESS_TOKEN=$MAPBOX_ACCESS_TOKEN" >> .tmp/env
echo "APPLICATION_INSIGHTS_INSTRUMENTATION_KEY=$APPLICATION_INSIGHTS_INSTRUMENTATION_KEY" >> .tmp/env
echo "ERP_API_ENDPOINT=$ERP_API_ENDPOINT" >> .tmp/env
echo "ERP_API_SUBSCRIPTION_KEY=$ERP_API_SUBSCRIPTION_KEY" >> .tmp/env
echo "SENTRY_DSN=$SENTRY_DSN" >> .tmp/env
echo "SENTRY_SAMPLE_RATE=$SENTRY_SAMPLE_RATE" >> .tmp/env

# TEST emails and other useful stuff
echo "TEST_EMAILS=$TEST_EMAILS" >> .tmp/env
echo "DEBUG_EMAIL=$DEBUG_EMAIL" >> .tmp/env
echo "PRODUCTION=$PRODUCTION" >> .tmp/env
echo "FDRS_CREDENTIAL=$FDRS_CREDENTIAL" >> .tmp/env
echo "FDRS_APIKEY=$FDRS_APIKEY" >> .tmp/env
echo "GO_VERSION=$GO_VERSION" >> .tmp/env

#echo "BULK_IMPORT=1" >> .tmp/env

scp -i .tmp/key .tmp/env $API_ADMIN@$IP:.env
scp -i .tmp/key $REPO_DIR/docker-compose-prod.yml $API_ADMIN@$IP:docker-compose.yml
scp -i .tmp/key .tmp/ifrcgoapi.crt $API_ADMIN@$IP:.ifrcgoapi.crt
scp -i .tmp/key .tmp/ifrcgoapi.key $API_ADMIN@$IP:.ifrcgoapi.key
ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP /bin/bash << EOF
  docker-compose pull
  docker-compose up -d
EOF

rm .tmp/env
rm .tmp/key
rm .tmp/ifrcgoapi.crt
rm .tmp/ifrcgoapi.key
