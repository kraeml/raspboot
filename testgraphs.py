#!/usr/bin/python
import matplotlib
matplotlib.use("Agg")

from matplotlib.dates import strpdate2num
import numpy as np
import pylab as pl

import os, time, headstails

os.nice(10)

def taildata():
  f = headstails.FileExtremities('/tmp/testser.txt','r')
  # read last 600 datapoints
  F = f.tail(600)

  h = file('/tmp/taildata.txt','w')
  for c in F:
    h.write("%s" % (c) )
  h.close()

def graphs():
  C=np.loadtxt('/tmp/taildata.txt',delimiter=',',converters={0:strpdate2num("%Y-%m-%d %H:%M:%S")})
  # 1 = ATMEGA chip
  # 2 = DS18B20
  # 3 = DHT22
  # 4 = RelHum
  # 5 = DP1
  # 6 = DP2
  # 7 = HeatIndex
  # 8 = Voltage
  # 9 = TMP36

  A1 = C[:,1]
  A1_extrema = [min(A1),max(A1)]
  A2 = C[:,2]
  A2_extrema = [min(A2),max(A2)]
  A3 = C[:,3]
  A3_extrema = [min(A3),max(A3)]
  A4 = C[:,4]
  A4_extrema = [min(A4),max(A4)]
  A5 = C[:,5]
  A5_extrema = [min(A5),max(A5)]
  A6 = C[:,6]
  A7 = C[:,7]
  A8 = C[:,8]
  A9 = C[:,9]
  A9_extrema = [min(A9),max(A9)]

  pl.close()
  ab = np.polyfit(A1,A2,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A1,A2)[0,1]
  pl.plot(A1,A2,'r.', label='ATMEGA vs. DS18B20', alpha=0.7)
  pl.plot(A1_extrema,fit(A1_extrema),'c-')
  pl.annotate('{0}'.format(r2) , xy=(min(A1)+0.5,fit(min(A1))), size=6, color='c' )
  print "ATMEGA vs. DS18B20"
  print ab
  print r2
  print ""

  ab = np.polyfit(A3,A2,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A3,A2)[0,1]
  pl.plot(A3,A2,'g.', label='DHT22 vs. DB18B20', alpha=0.7)
  pl.plot(A3_extrema,fit(A3_extrema),'m-')
  pl.annotate('{0}'.format(r2) , xy=(min(A3)+0.5,fit(min(A3))), size=6, color='m' )
  print "DHT22 vs. DS18B20"
  print ab
  print r2
  print ""

  ab = np.polyfit(A9,A2,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A9,A2)[0,1]
  pl.plot(A9,A2,'b.', label='TMP36 vs. DS18B20', alpha=0.7)
  pl.plot(A9_extrema,fit(A9_extrema),'y-')
  pl.annotate('{0}'.format(r2) , xy=(min(A9)+0.5,fit(min(A9))), size=6, color='y' )
  print "TMP36 vs. DS18B20"
  print ab
  print r2
  print ""

  pl.title('Sensor correlations')
  pl.xlabel("T(x) [degC]")
  pl.ylabel("T(y),DS18B20 [degC]")
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.savefig('/tmp/C123.png')


  ab = np.polyfit(A5,A6,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A5,A6)[0,1]
  print "Dewpoint1 vs. Dewpoint2"
  print ab
  print r2
  print ""
  pl.close()
  pl.plot(A5,A6,'b.')
  pl.plot(A5_extrema,fit(A5_extrema),'b-')
  pl.title('DewPoint vs. DewPoint2')
  pl.xlabel("Dewpoint(1) [degC]")
  pl.ylabel("Dewpoint(2) [degC]")
  pl.annotate('{0}'.format(r2) , xy=(min(A5)+0.5,fit(min(A6))), size=6 )
  pl.grid(True)
  pl.savefig('/tmp/C56.png')


  D = matplotlib.dates.num2date(C[:,0])

  pl.close()
  pl.plot(D,A1, '.r', label='ATMEGA')
  pl.plot(D,A2, '.y', label='DS18B20')
  pl.plot(D,A3, '.g', label='DHT22')
  pl.plot(D,A9, '.b', label='TMP36')
  pl.title('Temperature trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D123.png')

  pl.close()
  pl.plot(D,A4,'.b')
  pl.title('Relative humidity trend')
  pl.ylabel('RH [%]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D4.png')

  pl.close()
  pl.plot(D,A5,'.r', label='DP1')
  pl.plot(D,A6,'.b', label='DP2')
  pl.title('Dewpoint trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D56.png')

  pl.close()
  pl.plot(D,A7,'.b')
  pl.title('Heat Index trend')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D7.png')

  pl.close()
  pl.plot(D,A8,'.b')
  pl.title('Solar charge trend')
  pl.ylabel('Charge [V]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D8.png')

  return

if __name__ == "__main__":
  time.sleep(20)
  taildata()
  graphs()
