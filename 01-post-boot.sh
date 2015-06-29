#! /bin/bash

# This script only gets executed if `/tmp/raspboot.reboot` is absent...
# /tmp is in RAMFS, so everytime the server is rebooted, this script is executed.

ME=$(whoami)

# Check if the ~/bin directory exists
if [ ! -d ~/bin ]; then
  echo "Create ~/bin ..."
  mkdir ~/bin
fi

# /var/log is on tmpfs so recreate lastlog now
if [ ! -e /var/log/lastlog ]; then
  sudo touch /var/log/lastlog
  sudo chgrp utmp /var/log/lastlog
  sudo chmod 664 /var/log/lastlog
fi

# Download the contents of the ~/bin directory
# We use the `.rsyncd.secret` file as a flag.
# This allows a re-population of this directory in case new/updated binaries
# need to be installed.
if [ ! -e ~/bin/.rsyncd.secret ]; then
  echo "Populate ~/bin ..."
  sudo mount /mnt/backup
  cp -r /mnt/backup/rbmain/bin/. ~/bin
  sudo umount /mnt/backup
  # Set permissions
  chmod -R 0755 ~/bin
  chmod    0740 ~/bin/.rsyncd.secret
fi

echo "Boot detection mail... "$(date)
/home/$ME/bin/bootmail.py

# Additional scripts to be executed on the first boot after install.
# This makes the `raspbian-ua-netinst` installer more uniform and easier
# to maintain regardless of the use.
if [ ! -e /home/$ME/.firstboot ]; then
  echo -n "First boot detected on "
  date
  clientname=$(hostname)

  # 1. Update the system
  echo "Updating..."
  sudo apt-get update
  #echo "Upgrading..."
  #sudo apt-get -yuV upgrade

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
    sudo cp $f /$g
  done

  # 4. Modify existing server specific configuration files
  echo "Additional packages installation..."
  if [ -e ./$clientname/mod-files.sh ]; then
    source ./$clientname/mod-files.sh
  fi

  echo "Install raspdiagd..."
  git clone -b master https://github.com/Mausy5043/raspdiagd.git ~/raspdiagd
  # set permissions
  chmod -R 0755 ~/raspdiagd
  pushd ~/raspdiagd
    ./install.sh
  popd

  # Plant the flag and wrap up
  touch /home/$ME/.firstboot
  sudo shutdown -r +1 "First boot installation completed. Please log off now."
  echo -n "First boot installation completed on "
  date
fi
