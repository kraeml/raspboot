#! /bin/bash

CLNT=$(hostname)

MOUNTPOINT=/mnt/share1

# Check for the presence of the 'host.lock' file.
# If it exists, do nothing.
if [ ! -e $MOUNTPOINT/$CLNT/host.lock ]; then

	# Set our lock
	touch $MOUNTPOINT/$CLNT/client.lock

	# move the data-files
	if [ -e $MOUNTPOINT/$CLNT/client.lock ]; then
		cp /tmp/*.csv $MOUNTPOINT/$CLNT/
		if [ $? -eq 0 ]; then
			rm /tmp/*.csv
		fi
	fi

	# only for rbian; move graphs to server
	if [ -e $MOUNTPOINT/$CLNT/client.lock ]; then
		cp /tmp/*.png $MOUNTPOINT/$CLNT/
		if [ $? -eq 0 ]; then
			rm /tmp/*.png
		fi
	fi

	# copy error files to server
	if [ -e $MOUNTPOINT/$CLNT/client.lock ]; then
		cp /tmp/*.err $MOUNTPOINT/$CLNT/ 2>/dev/null
	fi

	# remove the lock
	rm $MOUNTPOINT/$CLNT/client.lock
fi
