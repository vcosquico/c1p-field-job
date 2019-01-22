#!/bin/bash

echo "[one platform field job] invoked"
notify_status "Retrieving%20locations" "25" 


###### QUERY ACCOUNT IDS AND INFORMATION #####
echo $C1P_ORGCREDENTIALID_DEMO_ENDPOINT
echo $C1P_ORGCREDENTIALID_DEMO_AUTH_HEADER


notify_status "Sending%20JSON" "%7B%20%22name%22%3A%22John%22%2C%20%22age%22%3A30%2C%20%22car%22%3Anull%20%7D"
