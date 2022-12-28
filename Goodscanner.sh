#!/bin/bash

# Check if IP address was provided
ip_address="$1"
if [ -z $ip_address ]
then
    echo "Please provide an IP address as an argument."
    exit 1
fi
# Check if -Pn option was provided
if [ "$2" == "-Pn" ]
then
    pn_option="-Pn"
else
    pn_option=""
fi
# Use a regular expression to check if the input is a valid IP address
if [[ $ip_address =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  # Split the IP address into its octets
  IFS='.' read -r o1 o2 o3 o4 <<< "$ip_address"

  # Check if each octet is between 0 and 255
  if [[ $o1 -ge 0 && $o1 -le 255 ]] && [[ $o2 -ge 0 && $o2 -le 255 ]] && [[ $o3 -ge 0 && $o3 -le 255 ]] && [[ $o4 -ge 0 && $o4 -le 255 ]]; then
    echo "Valid IP address -- wait for the script to return results"
  else
    echo "Invalid IP address -- please provide a valid IP address" && exit
  fi
else
  echo "Invalid IP address -- please provide a valid IP address" && exit
fi

# Echo starting scan
timestamp=$(date)
t1=$(date +%s)
echo "Common Ports Scan Initiated"
nmap $pn_option -T4 -sC -sV -vv -oN common."$ip_address".txt -p "$ip_address"
t2=$(date +%s)
elapsedtime=$((t2-t1))
echo "Common Port scanned in $elapsedtime seconds, waiting for Initial Scan"
# Echo starting scan
echo "Initial Scan Started on: "$timestamp" -- waiting for ports"

# Scan the IP address using the -T4, and -vv options for maximum speed and verbosity, then grep lines that contains "open ports", cut after /, 
# cut the fourth column that contains the port, translate newlines to commas, and finally remove commas from the end of the lines, leaving nothig but port number.

open_ports=$(nmap $pn_option -T4 -vv -oN sweep."$ip_address".txt -p- "$ip_address" | grep "open port" | cut -d'/' -f1 | cut -d" " -f4 | tr '\n' ',' | sed 's/,$//')

# Check if open_ports is empty
if [ -z $open_ports ]
   then 
   echo "No open ports were found -- exiting program" && exit
fi

# Echo second scan
timestamp=$(date)
echo "Ports found -- initiating deep scan, timestamp: "$timestamp""
t3=$(date +%s)
elapsedtime=$((t2-t1))
echo "Initial Scan completed in $elapsedtime seconds"

# Enumerate the services, Os, and script scan on the open ports using the -A option and -p "$open_ports" to scan only open ports.
nmap $pn_option -A -vv -oN scan."$ip_address".txt -p "$open_ports" "$ip_address"
echo -e "\n"
t4=$(date +%s)
elapsedtime=$((t4-t3))
totaltime=$((t4-t1))
timestamp=$(date)
echo "Deep scan successful, completed in "$elapsedtime" seconds, timestamp: "$timestamp""
echo "Full scan took "$totaltime" seconds to complete"
