#! /bin/bash

branch=$(cat ~/bin/gitbin.branch)
git checkout $branch
git fetch origin && git reset --hard origin/$branch && git clean -f -d

python -m compileall . >/dev/null
# Set permissions
chmod -R 744 *
