#! /bin/bash

# This script only gets executed if `/tmp/raspboot.reboot` is absent...
# /tmp is in RAMFS, so everytime the server is rebooted, this script is executed.

CLNT=$(hostname)
ME=$(whoami)

# /var/log is on tmpfs so recreate lastlog now
if [ ! -e /var/log/lastlog ]; then
  sudo touch /var/log/lastlog
  sudo chgrp utmp /var/log/lastlog
  sudo chmod 664 /var/log/lastlog
fi

# Check if the $HOME/bin directory exists
if [ ! -d $HOME/bin ]; then
  echo "Create $HOME/bin ..."
  mkdir -p $HOME/bin
fi

# Download the contents of the $HOME/bin directory
# We use the `.rsyncd.secret` file as a flag.
# This allows a re-population of this directory in case new/updated binaries
# need to be installed.
if [ ! -e $HOME/bin/.rsyncd.secret ]; then
  echo "Populate $HOME/bin ..."
  sudo mkdir -p /mnt/backup
  sudo mount    /mnt/backup
  cp -rv  /mnt/backup/rbmain/bin/.   $HOME/bin
  cp -rv  /mnt/backup/rbmain/.my.cnf $HOME/
  cp -rv  /mnt/backup/rbmain/.netrc  $HOME/
  sudo umount   /mnt/backup
  # Set permissions
  chmod -R 0755 $HOME/bin
  chmod    0740 $HOME/bin/.rsyncd.secret
  chmod    0740 $HOME/bin/.smbcifs
  chmod    0740 $HOME/.my.cnf
  chmod    0600 $HOME/.netrc
fi

echo "Boot detection mail... "$(date)
$HOME/bin/bootmail.py

# Additional scripts to be executed on the first boot after install.
# This makes the `raspbian-ua-netinst` installer more uniform and easier
# to maintain regardless of the use.
if [ ! -e $HOME/.firstboot ]; then
  echo -n "First boot detected on "
  date

  # 1. Update the system
  echo "Updating..."
  sudo apt-get update
  #echo "Upgrading..."
  #sudo apt-get -yuV upgrade

  # 2. Install server specific-packages
  echo "Additional packages installation..."
  if [ -e ./$CLNT/add-packages.sh ]; then
    source ./$CLNT/add-packages.sh
  fi

  # 3. Install server specific configuration files
  echo "Copy configuration files..."
  for f in ./$CLNT/config/*; do
    g=$(echo $(basename $f) | sed 's/@/\//g')
    echo $f " --> " $g
    # path must already exist for this to work:
    sudo cp $f /$g
  done

  echo "Set-up cron job(s)..."
  minit=$(echo $RANDOM/555 |bc)
  echo "MINIT = "$minit
  echo "$minit 23 * * * $HOME/bin/backuphome.sh" >> $HOME/cron.tmp
  /usr/bin/crontab -u $ME $HOME/cron.tmp
  rm $HOME/cron.tmp

  # 4. Modify existing server specific configuration files
  echo "Modify installation..."
  if [ -e ./$CLNT/mod-files.sh ]; then
    source ./$CLNT/mod-files.sh
  fi

  echo "Install raspdiagd..."
  git clone -b master https://github.com/Mausy5043/raspdiagd.git $HOME/raspdiagd
  # set permissions
  chmod -R 0755 $HOME/raspdiagd
  pushd $HOME/raspdiagd
    ./install.sh
  popd

  echo "Install lnxdiagd..."
  git clone -b master https://github.com/Mausy5043/lnxdiagd.git $HOME/lnxdiagd
  # set permissions
  chmod -R 0755 $HOME/lnxdiagd
  pushd $HOME/lnxdiagd
    ./install.sh
  popd

  # Plant the flag and wrap up
  if [ -e /bin/journalctl ]; then
    sudo usermod -a -G systemd-journal $ME
  fi
  touch $HOME/.firstboot

  sudo cat /dev/random | rngtest -c 5000

  sudo shutdown -r +1 "First boot installation completed. Please log off now."
  echo -n "First boot installation completed on "
  date
fi
