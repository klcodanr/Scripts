#!/bin/bash

# a script to make it easier for developers to start multiple CQ instances

function startcq
{
	cqjar=$(ls $cqdir | grep -m 1 ^.*cq.*\.jar$)
	cd $cqdir
	echo "Clearing logs"
	rm -f crx-quickstart/logs/*
	cmd="java -Xdebug $vmargs -Xrunjdwp:transport=dt_socket,server=y,address=$debugport,suspend=n -Dcom.sun.management.jmxremote.port=$jmxport -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -jar $cqjar $gui -nofork &> start.log &"
	echo "Starting CQ with: $cmd"
	$cmd
}

function usage
{
    echo "usage: start-cq [-v cq-version] [-r root-path] | [-p]"
}

# Default Settings
version=5.6.1
root=~/dev/cq
publish=
gui=-gui
vmargs="-Xmx1g -XX:MaxPermSize=256m"
debugport=30303
jmxport=9999

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
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

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
