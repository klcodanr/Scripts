#!/bin/bash

# a script to make it easier for developers to start multiple CQ instances

# Default Settings
version=5.6.1
root=~/dev/cq
publish=
debug="true"
gui=-gui
vmargs="-Xmx1g -XX:MaxPermSize=256m"
debugport=30303
jmxport=9999
action="start"

function help
{
	usage
	echo ""
	echo "---Actions---"
	echo " reset - deletes the contents of the crx-quickstart folder"
	echo " start - Starts the specified CQ"
	echo " stop - stops the specified CQ instance"
	echo ""
	echo "---Parameters---"
	echo "-v  | --version  - Sets the CQ version to use, will be a sub-folder of the root folder"
	echo "-vm | --vm-args  - Arguments passed to the JVM"
	echo "-ng | --no-gui   - Flag for not starting CQ's GUI"
	echo "-nd | --no-debug - Flag for not starting CQ in debug mode"
	echo "-h  | --help     - Displays this message"
}

function resetcq
{
	cd $cqdir
	echo "Clearing CQ repository at $cqdir"
	rm -rf crx-quickstart
	echo "Repository successfully cleared"
}

function startcq
{
	cqjar=$(ls $cqdir | grep -m 1 ^.*cq.*\.jar$)
	cd $cqdir
	echo "Clearing logs"
	rm -f crx-quickstart/logs/*
	mkdir -p crx-quickstart/logs
	mkdir -p crx-quickstart/conf
	echo "Starting CQ"
	echo "Using JAR $cqjar"
	if [ "$debug" = "true" ]; then
		echo "Using Debug Port $debugport"
		echo "Using JMX Port $jmxport"
		java -Xdebug $vmargs -Xrunjdwp:transport=dt_socket,server=y,address=$debugport,suspend=n -Dcom.sun.management.jmxremote.port=$jmxport -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -jar $cqjar $gui -nofork &
		echo $! > $cqdir/crx-quickstart/conf/cq.pid
	else
		java $vmargs -jar $cqjar $gui -nofork &
		echo $! > $cqdir/crx-quickstart/conf/cq.pid
	fi
}

function stopcq
{
	echo "Stopping CQ"
	$cqdir/crx-quickstart/bin/stop
	echo "CQ Stop Command Issued Successfully"
}

function usage
{
	echo "usage: start-cq [start|stop|reset] [-v cq-version] [-r root-path] [-p] [-vm '-Xmx2g'] [-nd]"
}


# Parse the command line arguments from the parameters
while [ "$1" != "" ]; do
	case $1 in
		-v | --version )		shift
								version=$1
								;;
		-vm | --vm-args )		shift
								vmargs=$1
								;;
		-r | --root )		   shift
								root=$1
								;;
		-p | --publish )		publish="1"
								;;
		-ng | --no-gui )		gui=
								;;
		-nd | --no-debug )		debug="false"
								;;
		-h | --help )		    help
								exit
								;;
		reset )		   		action="reset"
								;;
		start )		   		action="start"
								;;
		stop )		   		action="stop"
								;;
		* )					 usage
								exit 1
	esac
	shift
done

# Perform the actions
if [ "$action" = "start" ]; then
	cqdir=$root/$version
	startcq
	if [ "$publish" = "1" ]; then
		ls $root | grep ^$version-publish-.*$ | while read pub
		do
			debugport=$(expr $debugport + 1)
			jmxport=$(expr $jmxport + 1)
				cqdir=$root/$pub
				startcq
		done
	fi
elif [ "$action" = "reset" ] ; then
	cqdir=$root/$version
	resetcq
	if [ "$publish" = "1" ]; then
		ls $root | grep ^$version-publish-.*$ | while read pub
		do
				cqdir=$root/$pub
				resetcq
		done
	fi
elif [ "$action" = "stop" ] ; then
	cqdir=$root/$version
	stopcq
	if [ "$publish" = "1" ]; then
		ls $root | grep ^$version-publish-.*$ | while read pub
		do
				cqdir=$root/$pub
				stopcq
		done
	fi
fi
