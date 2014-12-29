#! /usr/bin/python

import sys, commands, time

def main():
    # Everybody! Remember where we parked! -Capt. Kirk
    orig_stdout = sys.stdout

    # Define output file
    f = file('/tmp/14-memory.csv', 'a')
    # Redefine system output to our file
    sys.stdout = f

    # Get the time and date in human-readable form...
    outDate = commands.getoutput("date '+%F %H:%M:%S'")
    # ... and machine-readable form (UNIX-epoch)
    outUxDate = commands.getoutput("date +%s")

    # memory /proc/meminfo
    # total = MemTotal
    # free = MemFree - (Buffers + Cached)
    # inUse = (MemTotal - MemFree) - (Buffers + Cached)
    # swaptotal = SwapTotal
    # swapUse = SwapTotal - SwapFree
    # ref: http://thoughtsbyclayg.blogspot.nl/2008/09/display-free-memory-on-linux-ubuntu.html
    # ref: http://serverfault.com/questions/85470/meaning-of-the-buffers-cache-line-in-the-output-of-free
    out = commands.getoutput("cat /proc/meminfo").splitlines()
    for line in range(0,len(out)-1):
        mem = out[line].split()
        if mem[0] == 'MemFree:':
            outMemFree = int(mem[1])
        elif mem[0] == 'MemTotal:':
            outMemTotal = int(mem[1])
        elif mem[0] == 'Buffers:':
            outMemBuf = int(mem[1])
        elif mem[0] == 'Cached:':
            outMemCache = int(mem[1])
        elif mem[0] == 'SwapTotal:':
            outMemSwapTotal = int(mem[1])
        elif mem[0] == "SwapFree:":
            outMemSwapFree = int(mem[1])

    outMemUsed = outMemTotal - (outMemFree + outMemBuf + outMemCache)
    outMemSwapUsed = outMemSwapTotal - outMemSwapFree

    # Print the data
    print '{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}'.format(outDate, outUxDate, outMemTotal, outMemUsed, outMemBuf, outMemCache, outMemFree, outMemSwapTotal, outMemSwapFree, outMemSwapUsed)

    # Close the file
    f.close()

    # Re-set the stdout
    sys.stdout = orig_stdout

if __name__ == "__main__":
    main()
