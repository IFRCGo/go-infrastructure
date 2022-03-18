#!/bin/bash

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api \
  --file .tmp/key

chmod 600 .tmp/key

eval `ssh-agent`

ssh-add .tmp/key
