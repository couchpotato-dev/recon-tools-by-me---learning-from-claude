#!/bin/bash

# ================================
#  passwordGenerator.sh - password generator
#  interactive, menu-driven
# ================================

echo ""
echo "=========================="
echo "    Password Generator    "
echo "=========================="
echo ""

read -p "Password length (8-64): " length

if [ -z "$length" ]; then
	echo "No length entered. Using default: 16"
	length=16
fi

if [ "$length" -lt 8 ] || [ "$length" -gt 64 ]; then
	echo "Out of range. Using default: 16"
	length=16
fi

echo ""
echo "Character set:"
echo " 1) Letters only           (abcABC)"
echo " 2) Letters + numbers      (abcABC123)"
echo " 3) Full (recommended)     (abcABC123!@#)"
echo ""
read -p "Choose [1-3]: " charset

case "$charset" in
	1) chars='A-Za-z' ;;
	2) chars='A-Za-z0-9' ;;
	3) chars='A-Za-z0-9!@#$%^&*()_+-=' ;;
	*) echo "Invalid choice. Using option 2."
		chars='A-Za-z0-9' ;;
esac

echo ""
read -p "How many passwords to generate? [1-20]: " count

if [ -z "$count" ] || [ "$count" -lt 1 ] || [ "$count" -gt 20 ]; then
	echo "Using default: 5"
	count=5
fi

echo ""
echo "--- Generated Passwords ---"
echo ""

i=1
while [ $i -le $count ]; do
	pass=$(cat /dev/urandom | tr -dc "$chars" | head -c "$length")
	echo " $i) $pass"
	i=$((i+1))
done

echo ""

read -p "Save to file? (y/n): " save

if [ "$save" = "y" ] || [ "$save" = "Y" ]; then
	outfile="passwords_$(date '+%Y%m%d_%H%M%S').txt"
	echo ""
	echo "Saved passwords:" > "$outfile"
	echo "Generated: $(date)" >> "$outfile"
	echo "Length: $length | Charset: $charset | Count: $count" >> "$outfile"
	echo "---" >> "$outfile"

	i=1
	while [ $i -le $count ]; do
		pass=$(cat /dev/urandom | tr -dc "$chars" | head -c "$length")
		echo " $i)   $pass" >> "$outfile"
		i=$((i + 1))
	done

	echo "Saved to: $outfile"
else
	echo "Not saved."
fi

echo ""
echo "Done."
echo ""

