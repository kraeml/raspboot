RASPBERRY-DATA
==============

Various scripts executed every minute to gather operational information from a Raspberry Pi.
The user `pi` has a cronjob defined as follows:

```
pi@raspberrypi ~ $ crontab -e

*/1 * * * * /home/pi/gitbin/00-run-scripts.sh 2>/tmp/gitbin.err 1>&2
```

The data is uploaded to a server where it is processed and graphed using rrdtool.
