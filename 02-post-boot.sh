#! /bin/bash


if [ ! -e ~/.rsyncd.secret ]; then
  sudo mount /mnt/backup
  cp /mnt/backup/rbmain/.rsyncd.secret ~/.rsyncd.secret
  cp /mnt/backup/rbmain/bin/* ~/bin/
  sudo umount /mnt/backup
fi
