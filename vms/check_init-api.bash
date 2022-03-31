cut -d'"' -f2 init-api.sh|grep '\$'|grep -v scp|grep -v ssh|grep -v '^ '|grep -v "(" |\
grep -v '^#' |\
grep -v AZURE_STORAGE_ACCOUNT |\
grep -v AZURE_STORAGE_KEY |\
grep -v BASE_DIR |\
grep -v REPO_DIR |\
grep -v FILE |\
grep -v API_FQDN > check0

grep -o =.*=  check0
grep ^'\$' check0

cut -d'=' -f1 check0 > check1
cut -d'=' -f2 check0|grep '\$'|cut -c 2- > check2
diff check1 check2
rm check?
