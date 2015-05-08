#! /bin/bash

# This script helps move the installation from "test" mode to "live" mode

sed -i 's/\#\.\/99-/\.\/99-/' /home/pi/raspboot/00-run-scripts.sh
sleep 120
sed -i 's/\#\.\/02-/\.\/02-/' /home/pi/raspboot/00-run-scripts.sh
echo
echo "*** Now live..."
echo
echo " Consider activating the nightly backups using crontab -e"
echo
