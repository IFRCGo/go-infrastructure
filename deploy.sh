# one-step deployment of IFRC GO infrastructure

if [[ ($1 = "") ]] ; then
   echo "Please enter an API docker image, ie:"
   echo "./deploy.sh ifrc/go-api:10"
   exit 1
fi

source .env
source bin/login.sh

source ./storage/deploy.sh
source ./storage/create-containers.sh
source ./storage/upload-key.sh ~/.ssh/ifrcgo

source ./vms/deploy-api.sh
source ./vms/deploy-es.sh

source ./db/deploy.sh
source ./db/extend.sh

source ./vms/open-ssh.sh
source ./vms/init-api.sh $1
source ./vms/init-es.sh
source ./vms/close-ssh.sh

source ./cdn/deploy.sh

source ./functions/deploy.sh
source ./functions/tag.sh
