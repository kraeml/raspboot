#! /bin/bash

# This script only gets executed if `/tmp/gitbin.reboot` is absent...

# Check if the ~/bin directory exists
if [ ! -d ~/bin ]; then
  mkdir ~/bin
fi

# Download the contents of the ~/bin directory
# We use the `.rsyncd.secret` file as a flag.
if [ ! -e ~/bin/.rsyncd.secret ]; then
  sudo mount /mnt/backup
  cp /mnt/backup/rbmain/bin/* ~/bin/
  sudo umount /mnt/backup
  # Set permissions
  chmod    0740 ~/bin/.rsyncd.secret
  chmod -R 0755 ~/bin
fi

if [ -e /home/pi/bin/bootmail.py ]; then
  /home/pi/bin/bootmail.py
fi

# Additional scripts to be executed on the first boot after install.
# This makes the installer more uniform and easier to maintain regardless of
# the use.
if [ ! -e /home/pi/.firstboot ]; then
  clientname=$(hostname)

  # 1. Update the system
  echo "...Updating"
  sudo apt-get update
  echo "...Upgrading"
  sudo apt-get -yuV upgrade

  # 2. Install server specific-packages
  echo "Additional packages installation..."
  if [ -e ./$clientname/add-packages.sh ]; then
    source ./$clientname/add-packages.sh
  fi

  # 3. Install server specific configuration files
  echo "Copy configuration files..."
  for f in ./$clientname/config/*; do
    g=$(echo $(basename $f) | sed 's/@/\//g')
    echo $f " --> " $g
    # path must already exist for this to work:
    cp $f /$g
  done

  # 4. Modify server specific configuration files
  echo "Additional packages installation..."
  if [ -e ./$clientname/mod-files.sh ]; then
    source ./$clientname/mod-files.sh
  fi

  # Place flag
  touch /home/pi/.firstboot
fi