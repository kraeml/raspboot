#! /bin/bash

MOUNTPOINT=/mnt/share1
MOUNTDRIVE=10.0.1.220:/srv/array1/dataspool
CLNT=$(hostname)
xml=/tmp/status.xml

# Mount the share containing the data
sudo mount $MOUNTDRIVE $MOUNTPOINT

if [ $? -eq 0 ]; then

	# Check if the drive really got mounted or not
	if grep -qs '/mnt/share1 ' /proc/mounts; then
		# It's mounted.

		# Check for the presence of the 'host.lock' file.
		# If it exists, do nothing.
		if [ ! -e $MOUNTPOINT/$CLNT/host.lock ]; then

			# Set our lock
			touch $MOUNTPOINT/$CLNT/client.lock

			# move the data-files
			if [ -e $MOUNTPOINT/$CLNT/client.lock ]
				cp /tmp/*.csv $MOUNTPOINT/$CLNT/
				if [ $? -eq 0 ]; then
		    	echo OK
					rm /tmp/*.csv
				fi
			fi


			if [ -e $MOUNTPOINT/$CLNT/client.lock ]
				cp $xml $MOUNTPOINT/$CLNT/
				if [ $? -eq 0 ]; then
					echo OK
					rm $xml
				fi
			fi

			# only for rbian; move graphs to server
			if [ -e $MOUNTPOINT/$CLNT/client.lock ]
				cp /tmp/*.png $MOUNTPOINT/$CLNT/
				if [ $? -eq 0 ]; then
					echo OK
					rm /tmp/*.png
				fi
			fi

			# copy error files to server
			if [ -e $MOUNTPOINT/$CLNT/client.lock ]
				cp /tmp/*.err $MOUNTPOINT/$CLNT/ 2>/dev/null
			fi

			# remove the lock
			rm $MOUNTPOINT/$CLNT/client.lock
		fi
	fi
fi

# Unmount the drive again
sudo umount $MOUNTPOINT
