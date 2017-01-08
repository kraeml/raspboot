RASPBOOT
========

Post-install scripts that need to be run after the first boot and that are run after every re-boot.

Cronjob stored in `/etc/cron.d/raspboot` by `raspbian-ua-netinst` and `raspberrypi-ua-netinst` via `mod-raspbian-ua-netinst` resp. `mod-raspberrypi-ua-netinst` :
```
*/1 *   * * *   pi  /home/pi/raspboot/00-run-scripts.sh 2>/tmp/raspboot.err 1>&2
```
and modified by `raspboot` upon first boot.

For the boot-detection to work properly the Raspberry Pi needs to have `/tmp` mounted on `tmpfs`. This requires an entry in `/etc/fstab` that looks like this:
```
tmpfs /tmp     tmpfs nodev,nosuid,mode=1777,size=30M              0 0
```
