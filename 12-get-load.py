#! /usr/bin/python

import sys, commands, time

def main():
    # Everybody! Remember where we parked! -Capt. Kirk
    orig_stdout = sys.stdout

    # Define output file
    f = file('/tmp/12-load-cpu.csv', 'a')
    # Redefine system output to our file
    sys.stdout = f

    # Get the time and date in human-readable form...
    outDate = commands.getoutput("date '+%F %H:%M:%S'")
    # ... and machine-readable form (UNIX-epoch)
    outUxDate = commands.getoutput("date +%s")

    outHistLoad = commands.getoutput("cat /proc/loadavg")
    outHistLoad = outHistLoad.replace(" ",", ")
    outHistLoad = outHistLoad.replace("/",", ")

    outCpu = commands.getoutput("vmstat 1 2").splitlines()[3].split()
    outCpuUS = outCpu[12]
    outCpuSY = outCpu[13]
    outCpuID = outCpu[14]
    outCpuWA = outCpu[15]
    outCpuST = "NaN"

    # Print the data
    print '{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}'.format(outDate, outUxDate, outHistLoad, outCpuUS, outCpuSY, outCpuID, outCpuWA, outCpuST)

    # Close the file
    f.close()

    # Re-set the stdout
    sys.stdout = orig_stdout

if __name__ == "__main__":
    main()
