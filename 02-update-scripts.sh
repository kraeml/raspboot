#! /bin/bash


ME=$(whoami)

branch=$(cat $HOME/.raspboot.branch)
git pull
git fetch origin
git checkout $branch && git reset --hard origin/$branch && git clean -f -d

# python -m compileall . >/dev/null
# Set permissions
chmod -R 744 *
