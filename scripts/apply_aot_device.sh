#!/system/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Error: Root privileges required. Run with su."
    exit 1
fi

echo "[*] Applying Ahead-Of-Time (AOT) and Performance Pipeline..."

settings put system min_refresh_rate 120.0
settings put system peak_refresh_rate 120.0
settings put system user_refresh_rate 120
settings put system speed_mode 2
settings put system miui_home_animation_rate 2

setprop ro.surface_flinger.max_frame_buffer_acquired_buffers 3
setprop ro.surface_flinger.vsync_phase_offset_ns 1000000
setprop ro.surface_flinger.vsync_sf_phase_offset_ns 1000000
setprop debug.sf.disable_backpressure 1
setprop debug.sf.latch_unsignaled 1
setprop persist.sys.miui.sf.high_latency 0
setprop ro.vendor.display.default_fps 120
setprop persist.vendor.power.dfps.enable false
setprop persist.sys.miui_animator_sched.enable false
setprop persist.sys.miui.home.speed_mode 2
setprop dalvik.vm.dex2oat-filter speed
setprop dalvik.vm.image-dex2oat-filter speed
setprop dalvik.vm.dex2oat-threads 8
setprop dalvik.vm.boot-dex2oat-threads 8

echo "[*] Pre-warming statusbar and Control Center..."
cmd statusbar expand-settings
sleep 0.2
cmd statusbar collapse

echo "[*] Compiling core packages to native machine code..."
CORE_PKGS="com.miui.home com.android.systemui com.android.settings com.miui.securitycenter com.google.android.gms com.android.vending"
for pkg in $CORE_PKGS; do
    if pm list packages | grep -q "$pkg"; then
        echo "  -> Compiling $pkg..."
        cmd package compile -m speed -f "$pkg" >/dev/null 2>&1 || true
    fi
done

echo "[+] Ahead-Of-Time optimization applied successfully!"
