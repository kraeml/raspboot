#!/usr/bin/python
import matplotlib
matplotlib.use("Agg")

from matplotlib.dates import strpdate2num
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
  C=np.loadtxt('/tmp/testser.txt',delimiter=',',converters={0:strpdate2num("%Y-%m-%d %H:%M:%S")})
  # 1 = TMP36
  # 2 = DS18B20
  # 3 = DHT22
  # 4 = RelHum
  # 5 = DP1
  # 6 = DP2
  # 7 = HeatIndex
  # 8 = Voltage


  pl.close()
  X = C[:,1]
  x_extrema = [min(X),max(X)]
  Y = C[:,2]
  ab = np.polyfit(X,Y,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(X,Y)[0,1]
  pl.plot(X,Y,'b.', label='TMP36 vs. DS18B20')
  pl.plot(x_extrema,fit(x_extrema),'b:')
  #pl.annotate(str(r2), )

  Y = C[:,3]
  ab = np.polyfit(X,Y,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(X,Y)[0,1]
  pl.plot(X,Y,'r.', label='TMP36 vs. DHT22')
  pl.plot(x_extrema,fit(x_extrema),'r:')

  X = C[:,2]
  ab = np.polyfit(X,Y,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(X,Y)[0,1]
  pl.plot(X,Y,'g.', label='DS18B20 vs. DHT22')
  pl.plot(x_extrema,fit(x_extrema),'g:')

  pl.title('Sensor correlations')
  pl.xlabel("x")
  pl.ylabel("y")
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.savefig('/tmp/C123.png')

  X = C[:,5]
  x_extrema = [min(X),max(X)]
  Y = C[:,6]
  ab = np.polyfit(X,Y,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(X,Y)[0,1]

  pl.close()
  pl.plot(X,Y,'b.', x_extrema,fit(x_extrema),'b:')
  pl.title('DewPoint vs. DewPoint2 (R2={0})'.format(r2))
  pl.xlabel("Dewpoint(1)")
  pl.ylabel("Dewpoint(2)")
  pl.grid(True)
  pl.savefig('/tmp/C56.png')


  D = matplotlib.dates.num2date(C[:,0])

  pl.close()
  pl.plot(D,C[:,1], '.r', label='TMP36')
  pl.plot(D,C[:,2], '.g', label='DS18*')
  pl.plot(D,C[:,3], '.b', label='DHT22')
  pl.title('Temperature trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D1.png')

  pl.close()
  pl.plot(D,C[:,4],'.b')
  pl.title('Relative humidity trend')
  pl.ylabel('RH [%]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D2.png')

  pl.close()
  pl.plot(D,C[:,5],'.r', label='DP1')
  pl.plot(D,C[:,6],'.b', label='DP2')
  pl.title('Dewpoint trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D3.png')

  pl.close()
  pl.plot(D,C[:,7],'.b')
  pl.title('Heat Index trend')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D4.png')

  pl.close()
  pl.plot(D,C[:,8],'.b')
  pl.title('Solar charge trend')
  pl.ylabel('Charge [V]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D5.png')

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
