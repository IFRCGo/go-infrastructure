[![Waffle.io - Columns and their card count](https://badge.waffle.io/IFRCGo/go-infrastructure.svg?columns=all)](https://waffle.io/IFRCGo/go-infrastructure)

# Go Infrastructure

## Preqrequisites

- [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Psql CLI tool](https://www.postgresql.org/docs/9.6/static/app-psql.html)

## Tile dependencies

*Only required if you're building tiles*

- NodeJS
- Yarn
- [Tippecanoe](https://github.com/mapbox/tippecanoe)

## Logging in

You must login before deploying any further assets

```(bash)
mv env-template .env
# Fill out private config in .env

source .env
source bin/login
```

## Creating storage

```(bash)
./storage/deploy.sh
```

### Uploading a private key to storage

```(bash)
# Upload both id_rsa *and* id_rsa.pub
./storage/upload-key.sh ~/.ssh/id_rsa
```

## Create and tag proxy functions

```(bash)
./functions/deploy.sh
./functions/tag.sh
```

## Deploy db

```(bash)
./db/deploy.sh
```

## Deploy API and Elasticsearch VMS

```(bash)
./vms/deploy-api.sh
./vms/deploy-es.sh

# Run a Docker image on a deployed VM
./vms/open-ssh.sh
./vms/init.sh dsgoapi developmentseed/ifrc-go-api:8
```

## Create and deploy tiles

```(bash)
yarn
./tiles/make-tiles.sh
./tiles/deploy.sh
```
