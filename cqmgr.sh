#!/bin/bash

# a script to make it easier for developers to start multiple CQ instances

function resetcq
{
	cd $cqdir
	echo "Clearing CQ repository at $cqdir"
	rm -rf crx-quickstart
	echo "Repository successfully cleared"w
}

function startcq
{
	cqjar=$(ls $cqdir | grep -m 1 ^.*cq.*\.jar$)
	cd $cqdir
	echo "Clearing logs"
	rm -f crx-quickstart/logs/*
	mkdir -p crx-quickstart/logs
	echo "Starting CQ"
	echo "Using JAR $cqjar"
	if [ "$debug" = "true" ]; then
		echo "Using Debug Port $debugport"
		echo "Using JMX Port $jmxport"
		java -Xdebug $vmargs -Xrunjdwp:transport=dt_socket,server=y,address=$debugport,suspend=n -Dcom.sun.management.jmxremote.port=$jmxport -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -jar $cqjar $gui -nofork &> crx-quickstart/logs/start.log &
	else
		java $vmargs -jar $cqjar $gui -nofork &> crx-quickstart/logs/start.log &
	fi
	echo "CQ Start Command Issued Successfully"
}

function usage
{
    echo "usage: start-cq [-v cq-version] [-r root-path] [-p]"
}

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

# Parse the command line arguments from the parameters
while [ "$1" != "" ]; do
    case $1 in
        -v | --version )		shift
                                version=$1
                                ;;
        -vm | --vm-args )		shift
                                vmargs=$1
                                ;;
        -r | --root )           shift
                                root=$1
                                ;;
        -p | --publish )    	publish="1"
                                ;;
        -ng | --no-gui )    	gui=
                                ;;
        -nd | --no-debug )    	debug="false"
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        reset )           		action="reset"
                                ;;
        start )           		action="start"
                                ;;
        * )                     usage
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
fi
