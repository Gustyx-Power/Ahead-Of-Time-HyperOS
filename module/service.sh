#!/system/bin/sh
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

settings put system min_refresh_rate 120.0
settings put system peak_refresh_rate 120.0
settings put system user_refresh_rate 120
settings put system speed_mode 2
settings put system miui_home_animation_rate 2

cmd statusbar expand-settings
sleep 0.2
cmd statusbar collapse

CORE_PKGS="com.miui.home com.android.systemui com.android.settings com.miui.securitycenter"
for pkg in $CORE_PKGS; do
    cmd package compile -m speed -f "$pkg" >/dev/null 2>&1 || true
done
