#! /bin/bash

minute=$(date "+%M")

if [ $minute -eq "42" ]; then
  # Update the git scripts once every hour
  # All output is logged by `logger`
  git fetch origin && git reset --hard origin/master && git clean -f -d
  # Log current status
  #git status
  # Set permissions
  chmod 744 *
fi
