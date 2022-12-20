#!/bin/bash

# Ask for input
read -p "Enter a remote host to scan: " remoteServer

# Get the IP address of the remote host
remoteServerIP=$(nslookup "$remoteServer" | grep 'Address' | tail -n1 | awk '{print $2}')

# Print a nice banner with information on which host we are about to scan
echo "---------------------------------------------"
echo "Please wait, scanning remote host $remoteServerIP"
echo "---------------------------------------------"

# Check what time the scan started
t1=$(date +%s)

# Scan all ports between 1 and 65535
for port in {1..65535}; do
  # Check if the port is open
  if nc -z "$remoteServerIP" "$port" &>/dev/null; then
    echo "Port $port: Open"
  fi
done

# Check the time again
t2=$(date +%s)

# Calculate the elapsed time of the scan
elapsedTime=$((t2-t1))

# Print the elapsed time
echo "Scan completed in $elapsedTime seconds"
