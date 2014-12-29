#! /bin/bash

if [ ! -e ~/bin/.rsyncd.secret ]; then
  sudo mount /mnt/backup
  cp /mnt/backup/rbmain/bin/* ~/bin/
  sudo umount /mnt/backup
fi
