# Deploying virtual machines

Deploy VMs with public IP's for elasticsearch and the API.

These VMs live on the same subnet, and share a network security group that allows http traffic on port 80 by default.

## Deploy

```(bash)
source ../.env
../bin/login
source ../storage/deploy
./deploy-api
./deploy-es
```

## Enable ssh

```(bash)
./open-ssh
```

## Disable ssh

```(bash)
./close-ssh
```

## Ssh into a vm

```(bash)
./init dsgoapi developmentseed/ifrc-go-api:0.1.5
```
