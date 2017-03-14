#!/bin/bash

#Configure the base directory for AEM
aemdir=/opt/aem

## Don't configure past this point
if [ ! -z "$1" ]
then
	aemdir=$1
	echo "Using $aemdir as base directory..." | tee -a $logfile
fi
today="$(date +'%Y-%m-%d')"
compactdir="$aemdir/help"
crxdir="$aemdir/crx-quickstart"
oakrun="$compactdir/oak-run-*.jar"
logfile="$compactdir/logs/compact-$today.log"

function compact
{

	repospace=$(du -hs $crxdir/repository)
	echo "Pre-compaction repository size: ${repospace}..." | tee -a $logfile
	
	echo "Finding old checkpoints..." | tee -a $logfile
	java -jar $oakrun checkpoints $crxdir/repository/segmentstore >> $logfile

	echo "Deleting unreferenced checkpoints..."
	java -jar $oakrun checkpoints $crxdir/repository/segmentstore rm-unreferenced >> $logfile
	
	echo "Running compaction. This may take a while..."
	java -jar $oakrun compact $crxdir/repository/segmentstore >> $logfile

	echo "Compaction complete. Please check the log at: $logfile" | tee -a $logfile

	echo "Restarting AEM..." | tee -a $logfile
	$crxdir/bin/start

	echo "Compaction complete!" | tee -a $logfile
	
	repospace=$(du -hs $crxdir/repository)
	echo "Post-compaction repository size: ${repospace}..." | tee -a $logfile
	
	exit 0
}


mkdir -p $compactdir/logs
echo "" > $logfile

echo "Running Compaction on $today" | tee -a $logfile

echo "Stopping AEM..." | tee -a $logfile
$crxdir/bin/stop >> $logfile
COUNTER=0
while [  $COUNTER -lt 30 ]; do
	echo "Checking if AEM Running..." | tee -a $logfile
	sleep 60
	if [ -f $FILE ]; then
		if pgrep -F $crxdir/conf/cq.pid > /dev/null 2>&1
		then
			echo "AEM still running..." | tee -a $logfile
		else
			echo "AEM Stopped, running compaction." | tee -a $logfile
			compact
		fi
	else
		echo "PID file not found, running compaction." | tee -a $logfile
		compact
	fi
done

echo "AEM Failed to stop in allotted time, exiting..."
exit 1
