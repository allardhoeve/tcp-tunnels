#!/bin/bash

whoami=`whoami`;

if [ "$whoami" != "root" ]; then
	echo "Run this as root";
	exit 1;
fi

set -e

echo "Checking to see if iodine is not already up"
iodine=$(pgrep iodine || /bin/true)

if [ ! -z "$iodine" ]; then
	echo "Iodine running as:";
	echo $iodine;
	kill $iodine;
else
	echo "Iodine not running";
fi
echo;

echo "Checking to see if the SSH tunnel is up"
sshtunnel=$(pgrep -f 'ssh -fNCD 3333' || /bin/true);

if [ ! -z "$sshtunnel" ]; then
	echo "SSH tunnel started"
	echo $sshtunnel	
	kill $sshtunnel
else
	echo "SSH tunnel not running"
fi
echo

echo "Resetting system-wide SOCKS proxy settings"
sudo networksetup -setsocksfirewallproxystate wi-fi off


echo "Testing SOCKS proxy"
response=$(curl -s --socks5 localhost:3333 http://www.henkslaaf.nl/ip.cgi || /bin/true)

if [ "$response" != "82.94.181.240" ]; then
	echo "Success! ($response)"
else
	echo;
	echo "FAILURE! The remote ip is still 82.94.181.240!";
	echo;
fi

