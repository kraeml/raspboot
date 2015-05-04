#! /bin/bash

logfile=/tmp/gitbin.err
CLNT=$(hostname)

# Timestamp the logfile
date

# Change PWD to the binaries directory
pushd /home/pi/gitbin

# Boot detection
if [ ! -e /tmp/gitbin.reboot ]; then
  # Set the flag first to prevent recursive execution
  whoami > /tmp/gitbin.reboot
  git config core.fileMode false
  ( ./01-post-boot.sh 2>&1 | tee -a ../post-boot.log | logger -p local7.info -t 01-post-boot ) &
fi

# Check for new/updated scripts
# Update the git scripts once every hour
minute=$(date "+%M")
if [ $minute -eq "42" ]; then
  ./02-update-scripts.sh
fi

# the $MOUNTPOINT is in /etc/fstab
# in the unlikely event that the mount was lost,
# remount it here.
MOUNTPOINT=/mnt/share1
MOUNTDRIVE=10.0.1.220:/srv/array1/dataspool
if grep -qs '/mnt/share1 ' /proc/mounts; then
	# It's mounted.
else
	# Mount the share containing the data
	sudo mount $MOUNTDRIVE $MOUNTPOINT
fi

# Execute client-specific scripts
case "$CLNT" in
  rbups )   echo "UPS monitor"
            ;;
  rbelec )  echo "Electricity monitor"
            ;;
  rbian )   echo "Raspberry testbench"
            ;;
  rxbmc )   echo "RaspBMC mediacenter"
            ;;
  osmc )    echo "OSMC Media Center"
            ;;
  * )       echo "!! undefined client !!"
            ;;
esac

sleep 3
# Upload the data
./99-upload-data.sh

date
popd
