#!/bin/bash


# ============================
# recon2.sh - stage 2 tool
# validates input, checks host
# ============================

echo ""
echo "====================="
echo "    Recon Tool v2    "
echo "====================="
echo ""

read -p "Enter target (domain or IP): " target

if [ -z "$target" ]; then
	echo "Error: no target entered. Exiting."
	exit 1
fi

if [ "$USER" = "root" ]; then
	echo "Running as root."
else
	echo "Not: not root. Some checks may be limited."
fi

echo ""
echo "--- Ping Check ---"

if ping -c 1 -W 2 "$target" > /dev/null 2>&1; then
	echo "[$target] is ALIVE"
	alive=1
else
	echo "$[$target] is NOT RESPONDING"
	alive=0
fi

if [ $alive -eq 1 ]; then
	echo ""
	echo "--- Port Check ---"

	for port in 22 80 443 8080; do
		if nc -zv -w 1 "$target" "$port" > /dev/null 2>&1; then
			echo -e "Port $port: OPEN"
		else
			echo -e "Port $port: CLOSED"
		fi
	done
else
	echo ""
	echo "Skipping port check - host did not respond."
fi

echo ""
echo "--- DNS Lookup ---"
resolved=$(host "$target" 2>/dev/null | head -1)

if [ -z "$resolved" ]; then
	echo "Could not resolve $target"
else
	echo "$resolved"
fi

echo ""
echo "--- Scan complete ---"
echo "Time: $(date '+%H:%M:%S')"
echo ""
