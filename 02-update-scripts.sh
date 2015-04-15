#! /bin/bash

branch=$(cat ~/bin/gitbin.branch)
git fetch origin && git reset --hard origin/$branch && git clean -f -d
