#! /usr/bin/python

import sys, commands, time

def main():
  # Everybody! Remember where we parked! -Capt. Kirk
  orig_stdout = sys.stdout

  # Define output file
  f = file('/tmp/13-nettraffic.csv', 'a')
  # Redefine system output to our file
  sys.stdout = f

  # Get the time and date in human-readable form...
  outDate = commands.getoutput("date '+%F %H:%M:%S'")
  # ... and machine-readable form (UNIX-epoch)
  outUxDate = commands.getoutput("date +%s")

  # Network traffic
  wlIn = "NaN"
  wlOut = "NaN"
  etIn = "NaN"
  etOut = "NaN"
  loIn = "NaN"
  loOut = "NaN"

  list = commands.getoutput("cat /proc/net/dev").splitlines()
  for line in range(2,len(list)):
    device = list[line].split()[0]
    if device == "lo:":
      loIn = list[line].split()[1]
      loOut = list[line].split()[9]
    if device == "eth0:":
      etIn = list[line].split()[1]
      etOut = list[line].split()[9]
    if device == "wlan0:":
      wlIn = list[line].split()[1]
      wlOut = list[line].split()[9]
    if device == "wlan1:":
      wlIn = list[line].split()[1]
      wlOut = list[line].split()[9]

  # Print the data
  print '{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}'.format(outDate, outUxDate, loIn, loOut, etIn, etOut, wlIn, wlOut)

  # Close the file
  f.close()

  # Re-set the stdout
  sys.stdout = orig_stdout

if __name__ == "__main__":
  main()
