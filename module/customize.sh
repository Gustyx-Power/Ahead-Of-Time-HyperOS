ui_print "***************************************************"
ui_print "*         Ahead-Of-Time (AOT) HyperOS             *"
ui_print "*             Optimizer by GustyxPower            *"
ui_print "***************************************************"
ui_print "- Installing system properties..."
ui_print "- Configuring SurfaceFlinger sub-1ms pipeline..."
ui_print "- Enforcing dalvik.vm.dex2oat-filter=speed..."
ui_print "- Setting up boot service..."

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/service.sh" 0 0 0755

ui_print "- Done! Reboot to enjoy AOSP-like speed on HyperOS."
