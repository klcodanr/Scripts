#!/bin/bash

RELEASE=$1

echo "Verifying release $RELEASE..."

echo "Updating GPG Keys..."
wget https://people.apache.org/keys/group/sling.asc -O /tmp/sling.asc -q
gpg --import /tmp/sling.asc > /dev/null 2>&1

echo "Checking Signatures..."
~/git/sling/check_staged_release.sh $RELEASE > ~/Desktop/$RELEASE-signatures.log 2>&1

echo "Running Build..."
~/git/sling/build_staged_release.sh $RELEASE > ~/Desktop/$RELEASE-build.log 2>&1

edit ~/Desktop/$RELEASE-signatures.log ~/Desktop/$RELEASE-build.log
