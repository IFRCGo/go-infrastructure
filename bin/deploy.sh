# Single deployment step

# Create env variables -
# See env-template for the variables this needs.
source ./.env

# Login to Azure
source ./bin/login.sh

# Deploy storage accounts, and add an AZURE_CONNECTION_STRING env variable
./storage/deploy.sh

# Generate an SSH key
# ./storage/upload-key.sh ~/.ssh/id_rsa

# Deploy postgres and extend it with POSTGIS extensions
./db/deploy.sh
./db/extend.sh

# Deploy function apps
./functions/deploy.sh
./functions/tag.sh

# Deploy API & ES VMS, and open SSH port
./functions/deploy-api.sh
./functions/deploy-es.sh
./functions/open-ssh.sh
