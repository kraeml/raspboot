#! /bin/bash

# Update the git scripts once every hour

branch=$(cat ~/bin/gitbin.branch)
git fetch origin && git reset --hard origin/$branch && git clean -f -d

python -m compileall .
# Set permissions
chmod -R 744 *
