#! /bin/bash

#git fetch origin && git reset --hard origin/master && git clean -f -d
git fetch origin
DIFFdmn=$(git --no-pager diff --name-only dev..origin/dev -- ./testdaemon/daemon.py)
DIFFlib=$(git --no-pager diff --name-only dev..origin/dev -- ./testdaemon/libdaemon.py)

git reset --hard origin/dev && git clean -f -d

python -m compileall .
# Set permissions
chmod -R 744 *

if [[ -n "$DIFFdmn" ]]; then
    logger "daemon has changed"
    ./testdaemon/daemon.py restart
fi

if [[ -n "$DIFFlib" ]]; then
    logger "daemonlib has changed"
    ./testdaemon/daemon.py stop
    sleep 1
    ./testdaemon/daemon.py start
fi
