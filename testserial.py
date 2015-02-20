#!/usr/bin/python
import matplotlib
matplotlib.use("Agg")
import numpy as np
import pylab as pl

import serial, commands, sys, time

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

def graphs():
  C12=np.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(1,2))
  C13=np.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(1,3))
  C23=np.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(2,3))
  C56=np.loadtxt('/tmp/testser.txt',delimiter=',',usecols=(5,6))
  # 1 = TMP36
  # 2 = DS18B20
  # 3 = DHT22
  # 4 = RelHum
  # 5 = DP1
  # 6 = DP2
  # 7 = HeatIndex
  # 8 = Voltage
  X = C12[:,0]
  Y = C12[:,1]
  (a,b)= np.polyfit(X,Y,1)
  cc = np.corrcoef(X,Y)[0,1]

  pl.close()
  pl.plot(X,Y, 'bo')
  pl.plot(X,(a*X+b), ':r')
  pl.title = 'TMP36 vs. DS18B20 ({0})'.format(cc)
  pl.xlabel=("T(tmp36)")
  pl.ylabel=("T(ds18b20)")

  pl.savefig('/tmp/C12.png')

  X = C23[:,0]
  Y = C23[:,1]
  (a,b)= np.polyfit(X,Y,1)
  cc = np.corrcoef(X,Y)[0,1]

  pl.close()
  pl.plot(X,Y, 'bo')
  pl.plot(X,(a*X+b), ':r')
  pl.title= 'DS18B20 vs. DHT22 ({0})'.format(cc)
  pl.xlabel=("T(ds18b20)")
  pl.ylabel=("T(dht22)")

  pl.savefig('/tmp/C23.png')

  X = C13[:,0]
  Y = C13[:,1]
  (a,b)= np.polyfit(X,Y,1)
  cc = np.corrcoef(X,Y)[0,1]

  pl.close()
  pl.plot(X,Y, 'bo')
  pl.plot(X,(a*X+b), ':r')
  pl.title = 'TMP36 vs. DHT22 ({0})'.format(cc)
  pl.xlabel=("T(tmp36)")
  pl.ylabel=("T(dht22)")

  pl.savefig('/tmp/C13.png')

  X = C56[:,0]
  Y = C56[:,1]
  (a,b)= np.polyfit(X,Y,1)
  cc = np.corrcoef(X,Y)[0,1]

  pl.close()
  pl.plot(X,Y, 'bo')
  pl.plot(X,(a*X+b), ':r')
  pl.title = 'DewPoint vs. DewPoint2 ({0})'.format(cc)
  pl.xlabel=("T(dp1)")
  pl.ylabel=("T(dp2)")

  pl.savefig('/tmp/C56.png')

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

  graphs()
