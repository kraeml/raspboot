#! /usr/bin/python

import sys, commands, time

def main():
    # Everybody! Remember where we parked! -Capt. Kirk
    orig_stdout = sys.stdout

    # Define output file
    f = file('/tmp/18-uptime.txt', 'a')
    # Redefine system output to our file
    sys.stdout = f

    # Get the time and date in human-readable form...
    outDate = commands.getoutput("date '+%F %H:%M:%S'")
    # ... and machine-readable form (UNIX-epoch)
    outUxDate = commands.getoutput("date +%s")


    uptime = commands.getoutput("cat /proc/uptime").split()


    # Print the data
    print '{0}, {1}, {2}, {3}'.format(outDate, outUxDate, uptime[0], uptime[1])

    # Close the file
    f.close()

    # Re-set the stdout
    sys.stdout = orig_stdout

if __name__ == "__main__":
    main()
