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
  ( ./01-post-boot.sh 2>&1 | tee -a ../post-boot.log | logger -p local7.info -t 01-post-boot ) &
fi

# Check for new/updated scripts
# Update the git scripts once every hour
minute=$(date "+%M")
if [ $minute -eq "42" ]; then
  ./02-update-scripts.sh
fi

# Execute client-specific scripts
case "$CLNT" in
  rbups )   echo "UPS monitor"
            ./16-get-upsstate.py
            ;;
  rbelec )  echo "Electricity monitor"
            #./17-get-electra.py
            ;;
  rbian )   echo "Raspberry testbench"
            #./testserial.py
            ;;
  rxbmc )   echo "RaspBMC mediacenter"
            ;;
  osmc )    echo "OSMC Media Center"
            ;;
  * )       echo "!! undefined client !!"
            ;;
esac

sleep 5
# Create the XML-file last
./31-xml-status.sh
# Upload the data
./99-upload-data.sh

date
popd
