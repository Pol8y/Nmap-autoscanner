#!/bin/bash

# Check if IP address was provided
if [ -z "$1" ]
then
    echo "Please provide an IP address as an argument."
    exit 1
fi

# Scan the IP address using the -T4, -A, and -vv options for maximum speed and verbosity
open_ports=$(nmap -T4 -A -vv -oG sweep."$1".txt -p- "$1" | grep open | cut -d'/' -f1 | tr '\n' ',' | sed '$

# Enumerate the services, Os, and script scan on the open ports using the -A option and -p "$open_ports" to scan only open ports.
nmap -A -vv -oG scan."$1".txt -p "$open_ports" "$1"
