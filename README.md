RASPBERRY-DATA
==============

Post-install scripts that need to be run after the first boot and that are run after every re-boot.

```
pi@raspberrypi ~ $ crontab -e

*/1 * * * * /home/pi/gitbin/00-run-scripts.sh 2>/tmp/gitbin.err 1>&2
```

For the boot-detection to work properly the Raspberry Pi needs to have `/tmp` mounted on `tmpfs`. This requires an entry in `/etc/fstab` that looks like this:
```
tmpfs /tmp     tmpfs nodev,nosuid,mode=1777,size=30M              0 0
```
