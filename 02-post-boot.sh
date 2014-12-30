#! /bin/bash

# This script only gets executed if `/tmp/gitbin.reboot` is absent...

if [ ! -d ~/bin ]; then
  mkdir ~/bin
fi

if [ ! -e ~/bin/.rsyncd.secret ]; then
  sudo mount /mnt/backup
  cp /mnt/backup/rbmain/bin/* ~/bin/
  sudo umount /mnt/backup
  # Set permissions
  chmod    0740 ~/bin/.rsyncd.secret
  chmod -R 0755 ~/bin
fi
