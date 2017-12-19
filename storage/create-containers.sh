#!/bin/bash

echo "Creating key storage container"
az storage container create \
  --name $KEY_CONTAINER \
  --public-access off

echo "Creating frontend storage container"
az storage container create \
  --name site \
  --public-access blob

echo "Creating tile storage container"
az storage container create \
  --name tiles \
  --public-access blob

echo "Creating api storage container"
az storage container create \
  --name api \
  --public-access blob
