#! /bin/bash

minute=$(date "+%M")

if [ $minute -eq "42" ]; then
  # Update the git scripts once every hour
  #pushd /home/pi/gitbin
  git fetch origin && git reset --hard origin/master && git clean -f -d
  git status
  chmod 744 *
  #popd
fi
