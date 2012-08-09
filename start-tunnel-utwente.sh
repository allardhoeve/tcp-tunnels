#!/bin/bash
ssh -vfNCD 3333 130.89.164.196

sudo networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 3333
sudo networksetup -setsocksfirewallproxystate wi-fi on
