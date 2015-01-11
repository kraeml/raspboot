#! /usr/bin/python

import sys, commands, time

def main():
  # Everybody! Remember where we parked! -Capt. Kirk
  orig_stdout = sys.stdout

  # Define output file
  f = file('/tmp/15-cnt-loglines.csv', 'a')
  # Redefine system output to our file
  sys.stdout = f

  # Get the time and date in human-readable form...
  outDate = commands.getoutput("date '+%F %H:%M:%S'")
  # ... and machine-readable form (UNIX-epoch)
  outUxDate = commands.getoutput("date +%s")

  kernlog = commands.getoutput("wc -l /var/log/kern.log").split()[0]
  messlog = commands.getoutput("wc -l /var/log/messages").split()[0]
  syslog = commands.getoutput("wc -l /var/log/syslog").split()[0]

  # Print the data
  print '{0}, {1}, {2}, {3}, {4}'.format(outDate, outUxDate, kernlog, messlog, syslog)

  # Close the file
  f.close()

  # Re-set the stdout
  sys.stdout = orig_stdout

if __name__ == "__main__":
  main()
