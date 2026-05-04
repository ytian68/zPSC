#!/bin/bash

# Usage: ./compare_dirs.sh <folderA> <folderB>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <folderA> <folderB>"
    exit 1
fi

A="$1"
B="$2"

# Validate both folders exist
if [ ! -d "$A" ]; then
    echo "ERROR: folder A '$A' does not exist"
    exit 1
fi
if [ ! -d "$B" ]; then
    echo "ERROR: folder B '$B' does not exist"
    exit 1
fi

echo "Comparing files in:"
echo "  A: $A"
echo "  B: $B"
echo ""

only_in_A=0
only_in_B=0
differ=0
same=0

# Check files in A against B
for fileA in "$A"/*; do
    [ ! -f "$fileA" ] && continue
    name=$(basename "$fileA")
    fileB="$B/$name"

    if [ ! -f "$fileB" ]; then
        echo "ONLY IN A : $name"
        ((only_in_A++))
    elif diff -q "$fileA" "$fileB" > /dev/null 2>&1; then
        echo "SAME      : $name"
        ((same++))
    else
        echo "DIFFER    : $name"
        ((differ++))
    fi
done

# Check files in B that are not in A
for fileB in "$B"/*; do
    [ ! -f "$fileB" ] && continue
    name=$(basename "$fileB")
    fileA="$A/$name"

    if [ ! -f "$fileA" ]; then
        echo "ONLY IN B : $name"
        ((only_in_B++))
    fi
done

# Summary
echo ""
echo "--- Summary ---"
echo "  Same      : $same"
echo "  Differ    : $differ"
echo "  Only in A : $only_in_A"
echo "  Only in B : $only_in_B"
