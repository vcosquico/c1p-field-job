#!/bin/bash

echo "[one platform field job] invoked"
printenv

notify_status "Retrieving_locations" "20" 
cat << EOF > ./locations.csv
"Skycart"; "1038 Leigh Ave #206, San Jose, CA 95126"; 37.3062222; -121.9211944
"Space Systems Loral"; "Bldg. 60, 1989 Little Orchard St, San Jose, CA 95125"; 37.3040833; -121.8720833
"BAE Systems"; "6331 San Ignacio Ave, San Jose, CA 95119"; 37.2388889; -121.7811944
"Hera Systems, Inc."; "7013 Realm Dr Suite B, San Jose, CA 95119 "; 37.2293889; -121.7775000
"Aviall"; "1538 Montague Expy, San Jose, CA 95131"; 37.4019520; -121.9019760
"ATK Missile Products"; "151 Martinvale Ln, San Jose, CA 95119"; 37.2305330; -121.7785510
"Kairos Aerospace"; "777 Cuesta Dr #202, Mountain View, CA 94040"; 37.3736720; -122.0866190
"Northrop Grumman"; "6379 San Ignacio Ave, San Jose, CA 95119"; 37.2370150; -121.7844210
"e2v inc"; "765 Sycamore Dr, Milpitas, CA 95035"; 37.4090480; -121.9187230
"Moon Express"; "19 N Akron Rd, Mountain View, CA 94043"; 37.4124200; -122.0587300
"Stellar Solutions"; "250 Cambridge Ave #204, Palo Alto, CA 94306"; 37.4291640; -122.1443240
EOF
sleep 2s

ITERATIONS=1000

notify_status "Computing_route" "40" 
java -jar tsp-0.0.1-SNAPSHOT.jar -i $ITERATIONS -s ./locations.csv -d ./route.kml
sleep 2s

notify_status "Uploading_route" "60" 
curl -sSX POST https://${COPADO_ENDPOINT_HOSTNAME}/oneworker/job/attach/${COPADO_JOB_ID} \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Content-Type: multipart/form-data' -H "Authorization: Bearer ${COPADO_API_TOKEN}" -F "file=@route.kml" \
  --connect-timeout 10
sleep 2s

notify_status "Finished" "90" 

echo "[one platform field job] finished"
