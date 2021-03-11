#/bin/bash

URL=$1
INTERVAL=$2

echo "Getting response times for ${URL} at interval ${INTERVAL}..."

while [  true ]; do
	 EXECUTION_TIME=$(curl -so /dev/null -w '%{time_total}\n' ${URL})
 	 CURRENT_TIME=$(date)
 	 echo "${CURRENT_TIME} ${EXECUTION_TIME}"
	 sleep ${INTERVAL}
done
