#!/bin/bash

whoami=`whoami`;

if [ "$whoami" != "root" ]; then
	echo "Run this as root";
	exit 1;
fi

if [ -e /etc/iodine_passwd ]; then
	IODINE_PASSWD=$(head -1 /etc/iodine_passwd | awk '{ print $1; }')
fi

if [ "x$IODINE_PASSWD" = "x" ]; then
	echo "Set the IODINE_PASSWD to /etc/iodine_passwd on a single line"
	exit 1;
fi 

set -e

echo "Checking to see if iodine is not already up"
iodine=$(pgrep iodine || /bin/true)

if [ ! -z "$iodine" ]; then
	echo "Iodine already running as:";
	echo $iodine;
else
	echo "Starting iodine";
	iodine -P $IODINE_PASSWD nl.nq.nl;
fi
echo;

echo "Checking to see if the SSH tunnel is already up"
sshtunnel=$(pgrep -f 'ssh -fNCD 3333' || /bin/true);

if [ ! -z "$sshtunnel" ]; then
	echo "SSH tunnel already started"
	echo $sshtunnel	
else
	echo "Starting SSH tunnel"
	ssh -fNCD 3333 socks@10.0.0.1
fi
echo

echo "Setting system-wide SOCKS proxy settings"
sudo networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 3333
sudo networksetup -setsocksfirewallproxystate wi-fi on


echo "Testing SOCKS proxy"
response=$(curl -s --socks5 localhost:3333 http://www.henkslaaf.nl/ip.cgi || /bin/true)

if [ "$response" = "82.94.181.240" ]; then
	echo "Success! ($response)"
else
	echo;
	echo "FAILURE! The remote ip is $response. Expected 82.94.181.240!";
	echo;
fi

