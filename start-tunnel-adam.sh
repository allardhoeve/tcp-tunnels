#!/bin/bash
ssh -vfNCD 3333 root@95.211.76.76

sudo networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 3333
sudo networksetup -setsocksfirewallproxystate wi-fi on
