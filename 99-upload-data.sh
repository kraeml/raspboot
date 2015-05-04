#! /bin/bash

MOUNTPOINT=/mnt/share1
MOUNTDRIVE=10.0.1.220:/srv/array1/dataspool
CLNT=$(hostname)
xml=/tmp/status.xml

function fun_makexml {
	xmlof=$MOUNTPOINT/$CLNT/status.xml

	echo "<server>" > $xmlof
	echo "<name>" >> $xmlof
	hostname >> $xmlof
	echo "</name>" >> $xmlof

	echo "<df>" >> $xmlof
	df -h >> $xmlof
	echo "</df>" >> $xmlof

	echo "<temperature>" >> $xmlof
	/opt/vc/bin/vcgencmd measure_temp >> $xmlof
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq >> $xmlof
	echo "</temperature>" >> $xmlof

	echo "<memusage>" >> $xmlof
	free -h >> $xmlof
	echo "</memusage>" >> $xmlof

	echo "<uptime>" >> $xmlof
	uptime >> $xmlof
	uname -a >> $xmlof
	echo -n "- raspdiagd on " >> $xmlof
	cat /home/pi/.raspdiagd.branch >> $xmlof
	echo -n "- gitbin on " >> $xmlof
	cat /home/pi/.gitbin.branch >> $xmlof
	echo "Top 6 processes:" >> $xmlof
	ps -e -o pcpu,args | awk 'NR>2' | sort -nr | head -6 | sed 's/&/\&amp;/g' | sed 's/>/\&gt;/g'>> $xmlof
	echo "</uptime>" >> $xmlof

	echo "</server>" >> $xmlof
}

# Check if the drive is mounted or not
if grep -qs '/mnt/share1 ' /proc/mounts; then
	# It's mounted.

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


		if [ -e $MOUNTPOINT/$CLNT/client.lock ]; then
			fun_makexml
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
else
	# Mount the share containing the data
	sudo mount $MOUNTDRIVE $MOUNTPOINT
fi


# Unmount the drive again
#sudo umount $MOUNTPOINT
