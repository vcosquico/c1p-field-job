#!/bin/bash

echo "[one platform field job] invoked"
notify_status "Retrieving%20locations" "25" 


###### QUERY ACCOUNT IDS AND INFORMATION #####
echo hola
curl "${C1P_ORGCREDENTIALID_DEMO_ENDPOINT}query?q=SELECT+id+FROM+Account" \
-H 'Authorization: Bearer '"$C1P_ORGCREDENTIALID_DEMO_AUTH_HEADER"''
