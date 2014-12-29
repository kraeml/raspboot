#! /bin/bash

logfile=/tmp/gitbin.err
CLNT=$(hostname)

# Boot detection
if [ ! -e /tmp/gitbin.reboot ]
  if [ -e /home/pi/bin/bootmail.py ]
    /home/pi/bin/bootmail.py
  fi
  cat whoami > /tmp/gitbin.reboot
fi

# Timestamp the logfile
echo $(date)

# Change PWD to the binaries directory
pushd /home/pi/gitbin

# Check for new/updated scripts
./01-update-scripts.sh | tee -a $logfile | logger -p local7.info -t 01-update-scripts

# Execute the common scripts in parallel
./11-get-temp.py & ./12-get-load.py & ./13-get-nettraffic.py & ./14-get-memory.py & ./31-xml-status.sh & wait

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

# Upload the data
./99-upload-data.sh

# Change PWD back to original
popd
