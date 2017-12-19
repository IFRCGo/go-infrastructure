# Deploying the IFRC GO Infrastructure

## Create an env file

The repo expects an `.env` file at the project root directory. See `env-template` for a reference on what configuration is needed.

Make sure to make the necessary modifications, such as to the `RESOURCE_GROUP` setting.

## Login

Login with the Azure credentials supplied in `.env`.

```(bash)
source .env
source bin/login.sh
```

## Deploy storage and upload an SSH key

First, create a storage account, then create storage containers for the various site elements.

```(bash)
source ./storage/deploy.sh
source ./storage/create-containers.sh
```

Then, generate an SSH key. Here are common approaches to this on [mac](https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-mac-os-x) and [windows](https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-windows).

Once you have created a new key, you will upload it to the key container. In the example below, my private key location is at `~/.ssh/id_rsa`. If yours is at a different location, you will need to adjust accordingly.

Now, upload your private and public keys to private storage.

```(bash)
source ./storage/upload-key.ssh ~/.ssh/id_rsa
```

Note, the above will upload both `id_rsa` and `id_rsa.pub`

## Deploy the database and add PostGIS extensions

```(bash)
source ./db/deploy.sh
source ./db/extend.sh
```

## Deploy API & Elasticsearch VMs

Deploy the VMs and open the ssh port

```(bash)
source ./vms/deploy-es.sh
source ./vms/deploy-api.sh
source ./vms/open-ssh.sh
```

Now run the Docker images. Assuming the latest version of the API is `ifrcgo/go-api:0.1.9`:

```(bash)
source ./vms/init-api.sh ifrcgo/go-api:0.1.9
source ./vms/init-es.sh
```

## Deploy Function apps

```(bash)
source ./functions/deploy.sh
source ./functions/tag.sh
```
