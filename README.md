RASPBERRY-DATA
==============

Various scripts executed every minute to gather operational information from a Raspberry Pi.
The user `pi` has a cronjob defined as follows:

```
pi@raspberrypi ~ $ crontab -e

*/1 * * * * /home/pi/gitbin/00-run-scripts.sh 2>/tmp/gitbin.err 1>&2
```

For the boot-detection to work properly the Raspberry Pi needs to have `/tmp` mounted on `tmpfs`. This requires an entry in `/etc/fstab` that looks like this:
```
tmpfs /tmp     tmpfs nodev,nosuid,mode=1777,size=30M              0 0
```

The data is uploaded to a server where it is processed and graphed using rrdtool.
