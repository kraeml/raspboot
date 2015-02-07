#!/usr/bin/python
import serial, commands, sys

port = serial.Serial('/dev/ttyACM0', 9600, timeout=1)

def gettelegram(cmd):
  # flag used to exit the while-loop
  abort = 0
  # countdown counter used to prevent infinite loops
  loops2go = 10

  while abort == 0:
    try:
      port.write(cmd)
      line = port.readline()
    except:
      # read error, terminate prematurely
      abort = 2

    if line != "":
      line = line.strip().split()
      if line[0] == cmd:
        if line[-1] == "!":
          telegram = line[-2]
          abort = 1

    loops2go = loops2go - 1
    if loops2go < 0:
      abort = 3

  # Return codes:
  # abort == 1 indicates a successful read
  # abort == 2 means that a serial port read/write error occurred
  # abort == 3 no valid data after several attempts

  return (telegram, abort)

if __name__ == "__main__":
  telegram, status = gettelegram("V")
  dt = commands.getoutput("date '+%F %H:%M:%S'")

  f = file('/tmp/testser.txt', 'a')
  f.write('{0}, {1}\n'.format(dt, telegram))
  #print '{0}, {1}'.format(dt, telegram)
  f.close()
