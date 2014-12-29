#! /bin/bash

# This only gets executed if `/tmp/gitbin.reboot` is absent...
if [ ! -e ~/bin/.rsyncd.secret ]; then
  sudo mount /mnt/backup
  cp /mnt/backup/rbmain/bin/* ~/bin/
  sudo umount /mnt/backup
fi
