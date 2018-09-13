#!/bin/bash

echo "[one platform field job] invoked"

notify_status "Retrieving_locations" "25" 
# get the account ids linked to the customer visit
curl -sS "${COPADO_SF_SERVICE_ENDPOINT}query?q=SELECT(select+Id+FROM+accounts__r)+FROM+Customer_Visit__c+WHERE+Id='$CV_ID'" \
-H 'Authorization: Bearer '"$COPADO_SF_AUTH_HEADER"'' | jq -r -c '.records[].Accounts__r.records[] | .Id '| \
tr '\n' ',' | tr -d " " | sed 's/.$//' | sed "s/,/','/g" | sed -e "s/^/'/g" | sed -e "s/$/'/g" > ./.accounts.id
# get the accounts information
curl -sS "${COPADO_SF_SERVICE_ENDPOINT}query?q=SELECT+Name,ShippingStreet,ShippingLatitude,ShippingLongitude+FROM+Account+where+Id+in($(cat ./.accounts.id))" \
-H 'Authorization: Bearer '"$COPADO_SF_AUTH_HEADER"'' | jq -c -r '.records[] | [.Name, .ShippingStreet, .ShippingLatitude, .ShippingLongitude]' | \
sed -Ee :1 -e 's/^(([^",]|"[^"]*")*),/\1;/;t1' | sed 's/[][]//g' > ./locations.csv

# compute get the estimated optimal route to visit all accounts
ITERATIONS="${ITERATIONS:-1000}"
notify_status "Computing_route" "50" 
java -jar tsp-0.0.1-SNAPSHOT.jar -i $ITERATIONS -s ./locations.csv -d ./route.kml

# Attach the route to the customer visit entity
notify_status "Uploading_route" "75" 
curl -sSX POST https://${COPADO_ENDPOINT_HOSTNAME}/oneworker/job/attachToParent/${CV_ID} \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Content-Type: multipart/form-data' -H "Authorization: Bearer ${COPADO_API_TOKEN}" -F "file=@route.kml" \
  --connect-timeout 10
  
notify_status "Finishing..." "100" 
echo "[one platform field job] finished"
