#!/usr/bin/python
import serial, commands, sys, time, numpy

port = serial.Serial('/dev/ttyACM0', 9600, timeout=10)

def gettelegram(cmd):
  # flag used to exit the while-loop
  abort = 0
  # countdown counter used to prevent infinite loops
  loops2go = 10
  #
  telegram = "NaN";

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
          telegram = ""
          for item in range(1,len(line)-1):
            telegram = telegram + ' {0}'.format(line[item])
          abort = 1

    loops2go = loops2go - 1
    if loops2go < 0:
      abort = 3

  # Return codes:
  # abort == 1 indicates a successful read
  # abort == 2 means that a serial port read/write error occurred
  # abort == 3 no valid data after several attempts

  return (telegram, abort)

def graphs()
  C12=numpy.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(1,2))
  C13=numpy.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(1,3))
  C23=numpy.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(2,3))
  C56=numpy.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(5,6))

  X = C12[:,0]
  Y = C12[:,1]
  title = "TMP36 vs. DS18B20"
  (a,b)= numpy.polyfit(X,Y,1)
  cc = numpy.corrcoef(X,Y)[0,1]

  savefig('C12.png', bbox_inches='tight')

  X = C23[:,0]
  Y = C23[:,1]
  title "DS18B20 vs. DHT22"
  (a,b)= numpy.polyfit(X,Y,1)
  cc = numpy.corrcoef(X,Y)[0,1]

  X = C13[:,0]
  Y = C13[:,1]
  title = "TMP36 vs. DHT22"
  (a,b)= numpy.polyfit(X,Y,1)
  cc = numpy.corrcoef(X,Y)[0,1]

  X = C56[:,0]
  Y = C56[:,1]
  title = "DewPoint vs. DewPoint2"
  (a,b)= numpy.polyfit(X,Y,1)
  cc = numpy.corrcoef(X,Y)[0,1]

  return

if __name__ == "__main__":
  telegram, status = gettelegram("S")
  time.sleep(2)
  telegram, status = gettelegram("A")
  dt = commands.getoutput("date '+%F %H:%M:%S'")
  if status == 1:
    f = file('/tmp/testser.txt', 'a')
    f.write('{0},{1}\n'.format(dt, telegram))
    f.close()
