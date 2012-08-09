#!/bin/bash
ssh -vfNCD 3333 -p 8080 root@95.97.9.242

echo
echo "Enter sudo password to enable proxy";
sudo networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 3333
sudo networksetup -setsocksfirewallproxystate wi-fi on
