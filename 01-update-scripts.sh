#! /bin/bash

minute=$(date "+%M")

if [ $minute -eq "42" ]; then
  # Update the git scripts once every hour
  # All output is logged by `logger`
  git fetch origin && git reset --hard origin/master && git clean -f -d
  # Log current status
  git status
  # Set permissions
  chmod 744 *

  if [ ! -e ~/.rsyncd.secret ]; then
    sudo mount /mnt/backup
    cp /mnt/backup/rbmain/.rsyncd.secret ~/.rsyncd.secret
    cp /mnt/backup/rbmain/bin/* ~/bin/
    sudo umount /mnt/backup
  fi
fi
