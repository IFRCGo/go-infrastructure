# Storage

Creates a storage account for blob and file storage.

Currently, `deploy.sh` creates this storage account and adds a single container that is private to the user, to store both public and private ssh keys.

These keys are then pulled down and used when creating VMs.

To create or update an ssh key, use `upload-key.sh`. Always deploy first as that sets environment variables necessary for uploading. If the storage container is already deployed, `deploy.sh` won't overwrite it.

```(bash)
source ./deploy.sh
source ./upload-key ~/local/path/to/key
```
