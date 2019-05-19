# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
properties() {
kernel.string= - by Feinzer @ GitHub
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=A0001
device.name2=bacon
}

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## end setup

# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
mount -o rw -t auto /system;
if [ -f /system/vendor/etc/init/hw/init.bacon.rc ]; then
  ui_print "       Adding Fz init patch in /system/vendor";
  cp /tmp/anykernel/ramdisk/init.fz.rc /system/vendor/etc/init/hw/init.fz.rc;
  insert_line /system/vendor/etc/init/hw/init.bacon.rc "init.fz" after "import /vendor/etc/init/hw/init.qcom-common.rc" "import /vendor/etc/init/hw/init.fz.rc";
  chmod 644 /system/vendor/etc/init/hw/init.fz.rc;
else
  ui_print "       Adding Fz init patch in /";
  cp /tmp/anykernel/ramdisk/init.fz.rc /init.fz.rc;
  insert_line init.bacon.rc "init.fz.rc" after "import /init.qcom.power.rc" "import /init.fz.rc";
  chmod 644 /init.fz.rc;
fi
umount /system;
# end ramdisk changes

write_boot;

## end install


