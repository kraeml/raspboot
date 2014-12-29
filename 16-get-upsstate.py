#! /usr/bin/python

import sys, commands, time

def main():
  # Everybody! Remember where we parked! -Capt. Kirk
  orig_stdout = sys.stdout

  # Define output file
  f = file('/tmp/16-aux-ups.csv', 'a')
  #Redefine system output to our file
  sys.stdout = f

  # Get the time and date in human-readable form...
  outDate = commands.getoutput("date '+%F %H:%M:%S'")
  # ... and machine-readable form (UNIX-epoch)
  outUxDate =commands.getoutput("date +%s")

  # UPS status
  outUPSvoltin = commands.getoutput("upsc ups@localhost input.voltage")
  outUPSvolt = commands.getoutput("upsc ups@localhost battery.voltage")
  outUPScharge = commands.getoutput("upsc ups@localhost battery.charge")
  outUPSload = commands.getoutput("upsc ups@localhost ups.load")
  outUPSrun = commands.getoutput("upsc ups@localhost battery.runtime")


  # Print the data
  print '{0}, {1}, {2}, {3}, {4}, {5}, {6}'.format(outDate, outUxDate, outUPSvoltin, outUPSvolt, outUPScharge, outUPSload, outUPSrun)

  # Close the file
  f.close()

  # Re-set the stdout
  sys.stdout = orig_stdout

if __name__ == "__main__":
  main()
