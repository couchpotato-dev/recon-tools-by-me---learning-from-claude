#!/bin/bash

# ==============================
# quickrecon.sh - beginner tool
# check if a host is alive
# ==============================

echo ""
echo "========================"
echo "    Quick Recon Tool    "
echo "========================"
echo ""

read -p "Enter target (domain or IP): " target

myip=$(hostname -I | cut -d' ' -f1)
myname=$USER
timestamp=$(date '+Y%-%m-%d %H:%M:%S')

echo ""
echo "--- Scan Info ---"
echo -e "Operator\t: $myname"
echo -e "Your IP\t\t: $myip"
echo -e "Target\t\t: $target"
echo -e "Time\t\t: $timestamp"
echo ""

echo "--- Ping Check ---"
ping -c 1 -W 2 $target > /dev/null 2>&1
result=$?

if [ $result -eq 0 ]; then
	echo -e "Status\t\t: ALIVE"
else
	echo -e "Status\t\t: NO RESPONSE"
fi

echo ""

echo "--- DNS Lookup ---"
resolved=$(host $target 2>/dev/null | head -1)
echo "$resolved"

echo ""

echo "--- Port Peek (top 3 ports) ---"
nc -zv -w 1 $target 22 2>&1 | tail -1
nc -zv -w 1 $target 80 2>&1 | tail -1
nc -zv -w 1 $target 443 2>&1 | tail -1

echo ""
echo "--- Done ---"
echo ""
