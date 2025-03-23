#!/bin/sh

trap ctrl_c INT

function ctrl_c() {
	killall smcrouted
}


echo "============== IP Info ===========+=="
ifconfig
echo "-----"
cat /proc/net/dev_mcast
echo "-------------- Starting -------------"
if [ "$CMDOPTS" = "" ]; then
	echo "ERROR: Missing CMDOPTS environment variable"
	exit 1;
else
	cmd="smcrouted $CMDOPTS"
	echo $cmd
	$cmd
fi
