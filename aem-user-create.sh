#!/bin/bash

LIMIT=100000
COUNTER=0
MOD=1000
LAST=$(date +%s)
echo "Users,Time" > run.csv
while [  $COUNTER -lt $LIMIT ]; do
	 echo "Creating user-$COUNTER..."
	 curl -s -o /dev/null -u admin:admin -FcreateUser= -FauthorizableId=user-$COUNTER -Frep:password=password$COUNTER -Fmembership=everyone -Fmembership=contributor http://localhost:4502/libs/granite/security/post/authorizables > /dev/null
	 if (( $COUNTER % $MOD == 0 ))
	 then
	 	NOW=$(date +%s)
	 	let TIME=$NOW-$LAST
	 	echo "$COUNTER,$TIME" >> run.csv
	 	echo "Created $COUNTER users in $TIME seconds"
	 	LAST=$NOW
	 fi
	 let COUNTER=$COUNTER+1 
	 
done
