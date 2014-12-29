#! /bin/bash

logfile=/tmp/gitbin.err
CLNT=$(hostname)

# Change PWD to the binaries directory
pushd /home/pi/gitbin

# Timestamp the logfile
echo $(date)

# Boot detection
if [ ! -e /tmp/gitbin.reboot ]; then
  ./02-post-boot.sh
  if [ -e /home/pi/bin/bootmail.py ]; then
    /home/pi/bin/bootmail.py
  fi
  whoami > /tmp/gitbin.reboot
fi

# Check for new/updated scripts
./01-update-scripts.sh | tee -a $logfile | logger -p local7.info -t 01-update-scripts

# Execute the common scripts in parallel
./11-get-temp.py & ./12-get-load.py & ./13-get-nettraffic.py & ./14-get-memory.py & wait

# Execute client-specific scripts
case "$CLNT" in
  rbups )   echo "UPS monitor"
            ./16-get-upsstate.py
            ;;
  rbian )   echo "Raspberry testbench"
            ;;
  * )       echo "!! undefined client !!"
            ;;
esac

# Create the XML-file last
./31-xml-status.sh
# Upload the data
./99-upload-data.sh

# Change PWD back to original
popd
