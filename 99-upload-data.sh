#! /bin/bash

MOUNTPOINT=/mnt/share1
MOUNTDRIVE=10.0.1.220:/srv/array1/dataspool
CLNT=$(hostname)
xml=/tmp/status.xml

# Mount the share containing the data
sudo mount $MOUNTDRIVE $MOUNTPOINT

# Check if the drive actually got mounted or not
if grep -qs '/mnt/share1 ' /proc/mounts; then
	# It's mounted.
	# Set our lock
	touch $MOUNTPOINT/$CLNT/client.lock
	# Check for the presence of the 'host.lock' file.
	# If it exists, do nothing.
	if [ ! -e $MOUNTPOINT/$CLNT/host.lock ]; then
		# move the data
		cp /tmp/*.csv $MOUNTPOINT/$CLNT/
		if [ $? -eq 0 ]; then
    	echo OK
			rm /tmp/*.csv
		fi
		cp $xml $MOUNTPOINT/$CLNT/
		if [ $? -eq 0 ]; then
			echo OK
			rm $xml
		fi
		cp /tmp/*.png $MOUNTPOINT/$CLNT/
		if [ $? -eq 0 ]; then
			echo OK
			rm /tmp/*.png
		fi
		cp /tmp/*.err $MOUNTPOINT/$CLNT/ 2>/dev/null
		# remove the lock
		rm $MOUNTPOINT/$CLNT/client.lock
	fi
	# Unmount the drive again
	sudo umount $MOUNTPOINT
fi
