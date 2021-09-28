#!/bin/bash

rm -f                                                                  nslinks
wget 'https://prddsgocdnapi.azureedge.net/api/v2/nslinks?limit=200' -O nslinks
perl -pi -w -e 's/\}/\n/g'                                             nslinks
perl -pi -w -e 's/^.*url_ifrc...//;s/^.\n//;s/"//'                     nslinks

cd results
rm -f *
cat ../nslinks|xargs -iQ sh -c "sleep 1 ; curl -s Q|grep 'h2 class=.page-hero' > \$(echo Q|sed 's/^.*\///') &"

# Example: https://www.ifrc.org/national-societies-directory/bangladesh-red-crescent-society
