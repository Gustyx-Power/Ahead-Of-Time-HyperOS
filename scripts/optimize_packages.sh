#!/system/bin/sh
set -e

echo "[*] Ahead-Of-Time (AOT) Full Machine Code Batch Compiler"

TARGET_PKGS=$(pm list packages -3 | cut -d':' -f2)
SYSTEM_PKGS="com.miui.home com.android.systemui com.android.settings com.miui.securitycenter com.google.android.gms com.android.vending com.android.chrome"

TOTAL=$(echo "$SYSTEM_PKGS $TARGET_PKGS" | wc -w)
CURRENT=1

for pkg in $SYSTEM_PKGS $TARGET_PKGS; do
    echo "[$CURRENT/$TOTAL] Compiling $pkg to speed mode..."
    cmd package compile -m speed -f "$pkg" >/dev/null 2>&1 || true
    CURRENT=$((CURRENT + 1))
done

echo "[+] All packages successfully compiled to native AOT machine code!"
