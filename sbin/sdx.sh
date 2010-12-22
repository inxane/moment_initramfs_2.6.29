#!/system/bin/sh
# establish root in common system directories for 3rd party applications
/system/bin/mount -o remount,rw -t rfs /dev/stl5 /system
/system/bin/rm /system/bin/su
/system/bin/rm /system/xbin/su
/system/bin/rm /system/bin/ifconfig
/system/bin/rm /system/xbin/ifconfig
/system/bin/rm /system/bin/route
/system/bin/rm /system/xbin/route
/system/bin/ln -s /sbin/su /system/bin/su
/system/bin/ln -s /sbin/su /system/xbin/su
/system/bin/ln -s /sbin/busybox /system/bin/ifconfig
/system/bin/ln -s /sbin/busybox /system/xbin/ifconfig
/system/bin/ln -s /sbin/busybox /system/bin/route
/system/bin/ln -s /sbin/busybox /system/xbin/route
/sbin/busybox install -s
# fix busybox DNS while system is read-write
if [ ! -f "/system/etc/resolv.conf" ]; then
  echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
  echo "nameserver 8.8.8.4" >> /system/etc/resolv.conf
fi
#setup proper passwd and group files for 3rd party root access
if [ ! -f "/system/etc/passwd" ]; then
	echo "root::0:0:root:/data/local:/system/bin/sh" > /system/etc/passwd
	chmod 0666 /system/etc/passwd
fi
if [ ! -f "/system/etc/group" ]; then
	echo "root::0:" > /system/etc/group
	chmod 0666 /system/etc/group
fi
/system/bin/mount -o remount,ro -t rfs /dev/stl5 /system

#provide support for a shell script to protect root access
if [ -r "/system/protectsu.sh" ]; then
  /system/bin/sh /system/protectsu.sh
fi
r
