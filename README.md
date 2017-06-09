RASPBOOT
========

Post-install scripts that need to be run after the first boot and/or that are run after every re-boot.

## Requirements
This repository aswell as a `cron` job in `/etc/cron.d/raspboot` is installed by `raspbian-ua-netinst` and `raspberrypi-ua-netinst` via `mod-raspbian-ua-netinst` resp. `mod-raspberrypi-ua-netinst`. It looks something like this:
```
*/1 *   * * *   pi  /home/pi/raspboot/00-run-scripts.sh 2>/tmp/raspboot.err 1>&2
```
This makes sure that a script is run at first boot.

For the boot-detection to work properly the Raspberry Pi needs to have `/tmp` mounted on `tmpfs`. 
