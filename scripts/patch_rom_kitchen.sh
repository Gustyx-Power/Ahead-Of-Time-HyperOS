#!/bin/bash
set -e

TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR" ]; then
    echo "Usage: $0 <path_to_unpacked_rom_or_system_mount>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROP_SOURCE="$SCRIPT_DIR/../configs/aot_hyperos.prop"

if [ ! -f "$PROP_SOURCE" ]; then
    echo "[!] Error: Configuration file $PROP_SOURCE not found."
    exit 1
fi

echo "[*] Searching build.prop targets in $TARGET_DIR..."

FOUND=0
for prop in $(find "$TARGET_DIR" -type f -name "build.prop"); do
    echo "  -> Injecting AOT properties into $prop..."
    while IFS= read -r line || [ -n "$line" ]; do
        [ -z "$line" ] && continue
        key=$(echo "$line" | cut -d'=' -f1)
        if grep -q "^$key=" "$prop"; then
            sed -i "s|^$key=.*|$line|" "$prop"
        else
            echo "$line" >> "$prop"
        fi
    done < "$PROP_SOURCE"
    FOUND=$((FOUND + 1))
done

if [ "$FOUND" -eq 0 ]; then
    echo "[!] Warning: No build.prop found in $TARGET_DIR"
    exit 1
fi

JOYOSE_DIRS=$(find "$TARGET_DIR" -type d -name "Joyose")
for jdir in $JOYOSE_DIRS; do
    echo "  -> Removing Joyose directory: $jdir"
    rm -rf "$jdir"
done

echo "[+] ROM Kitchen patching completed successfully! ($FOUND build.prop files updated)"
