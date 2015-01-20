#! /bin/bash

minute=$(date "+%M")

if [ $minute -eq "42" ]; then
  # Update the git scripts once every hour
  
  #git fetch origin && git reset --hard origin/master && git clean -f -d
  git fetch origin && git reset --hard origin/dev && git clean -f -d

  python -m compileall .
  # Set permissions
  chmod -R 744 *
fi
