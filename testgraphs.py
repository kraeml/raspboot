#!/usr/bin/python
import matplotlib
matplotlib.use("Agg")

from matplotlib.dates import strpdate2num
import numpy as np
import pylab as pl
import os, time, headstails, commands

os.nice(10)

def taildata():
  print "Tailing sensor-data"
  fin = headstails.FileExtremities('/tmp/testser.txt','r')
  # read last 1200 datapoints
  F = fin.tail(1200)

  fout = file('/tmp/taildata.txt','w')
  for c in F:
    fout.write("%s" % (c) )
  fout.close()

def graphs():
  print "Loading sensor-data"
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
  # 10= BMP183 Pressure
  # 11= BMP183 Temperature
  # 12= loopcounter
  # 13= windspeed (Gilze-Rijen)
  # 14= winddirection (Gilze-Rijen)
  # 15= WindChill

  #A1 = C[:,1]
  A2 = C[:,2]
  A3 = C[:,3]
  A4 = C[:,4]
  A5 = C[:,5]
  A6 = C[:,6]
  A7 = C[:,7]
  A8 = C[:,8]
  A9 = C[:,9]
  A10 = C[:,10]
  A11 = C[:,11]
  A11_extrema = [min(A11),max(A11)]
  A15 = C[:,15]

  D = matplotlib.dates.num2date(C[:,0])
  ahpla = 0.3

  #print "Sensor differences graph"
  pl.close()
  print "Sensor differences graph"
  pl.title('Sensor differences')
  A32 = np.subtract(A3,A2)
  #print "DHT22 vs. DS18B20"
  pl.plot(D,A32,'g.', label='DHT22  vs. DB18B20', alpha=ahpla)
  A92 = np.subtract(A9,A2)
  #print "TMP36 vs. DS18B20"
  pl.plot(D,A92,'b.', label='TMP36  vs. DS18B20', alpha=ahpla)
  A112 = np.subtract(A11,A2)
  #print "BMP183 vs. DS18B20"
  pl.plot(D,A112,'m.', label='BMP183 vs. DS18B20', alpha=ahpla)
  pl.ylabel("T(x)-T(DS18B20) [degC]")
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/C123.png')

  print "BMP183 vs DS18B20"
  ab = np.polyfit(A11,A2,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A11,A2)[0,1]
  print ab[0], ab[1], r2
  pl.close()
  pl.plot(A11,A2,'m.', alpha=ahpla)
  pl.plot(A11_extrema,fit(A11_extrema),'b-', alpha=ahpla)
  pl.title('BMP183 vs. DS18B20')
  pl.xlabel("T(BMP183) [degC]")
  pl.ylabel("T(DS18B20) [degC]")
  pl.annotate('{0}'.format(r2) , xy=(min(A11)+0.5,fit(min(A11))), size=6 )
  pl.grid(True)
  pl.savefig('/tmp/C56.png')

  pl.close()
  print "Temperature trends"
  pl.plot(D,A2, '.k', label='DS18B20', alpha=ahpla)
  pl.plot(D,A3, '.g', label='DHT22', alpha=ahpla)
  pl.plot(D,A9, '.y', label='TMP36', alpha=ahpla)
  pl.plot(D,A11, '.m', label='BMP183', alpha=ahpla)
  pl.title('Temperature trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D123.png')

  pl.close()
  print "Relative humidity trend"
  pl.plot(D,A4,'.b', alpha=ahpla)
  pl.title('Relative humidity trend')
  pl.ylabel('RH [%]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D4.png')

  pl.close()
  print "Dewpoint trend"
  #pl.plot(D,A5,'.r', label='DP1', alpha=ahpla)
  pl.plot(D,A6,'.b', alpha=ahpla)
  pl.title('Dewpoint trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D56.png')

  pl.close()
  print "Temperature trends"
  pl.plot(D,A2, '.k', label='Temperature', alpha=ahpla)
  pl.plot(D,A7,'.r', label='Heat Index', alpha=ahpla)
  pl.plot(D,A15,'.b', label='WindChill', alpha=ahpla)
  pl.plot(D,A6,'.y', label='DewPoint', alpha=ahpla)
  pl.title('Temperature')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D7.png')

  pl.close()
  print "Solar charger trend"
  pl.plot(D,A8,'.b', alpha=ahpla)
  pl.title('Solar charge trend')
  pl.ylabel('Charge [V]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D8.png')

  # calculate pressure trend
  Tr1="?"
  L1 = 60/5
  Tr3="?"
  L3 = (60/5)*3
  delta1=0
  delta3=0

  lenD=len(D)
  Pnow = "{0:.1f}mbara ".format(A10[lenD-1])
  Prain = rainchance(A10[lenD -1])
  Ptrend = Pnow + "Neerslagkans: {0}% \n".format(Prain)

  # SyntaxError: Non-ASCII character '\xe2' in file /home/pi/gitbin/testgraphs.py
  # on line 244, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details
  # Charactercodes: http://www.fileformat.info/info/unicode/block/arrows/utf8test.htm

  if ( lenD > L1 ):
    delta1 = float(A10[lenD-1] - A10[lenD-1-L1])
    if ((delta1 <= 0.15) & (delta1 >= -0.15)):
      Tr1=u'\u21D2'
    if (delta1 > 0.15):
      Tr1=u'\u21D7'
    if (delta1 < -0.15):
      Tr1=u'\u21D8'

  Ptrend = Ptrend + "1h {0:.2f}: ".format(delta1) + Tr1

  if ( lenD > L3 ):
    delta3 = float(A10[lenD-1] - A10[lenD-1-L3])
    if ((delta3 <= 0.20) & (delta3 >= -0.20)):
      Tr3=u'\u21D2'
    if (delta3 > 0.20):
      Tr3=u'\u21D7'
    if (delta3 < -0.20):
      Tr3=u'\u21D8'

  Ptrend = Ptrend + " | 3h {0:.2f}: ".format(delta3) + Tr3

  pl.close()
  print "Pressure trend"
  pl.plot(D,A10,'.b', alpha=ahpla)
  pl.title('Pressure trend')
  pl.ylabel('Pressure [mbara]')
  pl.grid(True)
  pl.annotate(Ptrend , xy=(0.1, 0.5), xycoords='axes fraction', size=12 )
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D11.png')

  return

def rainchance(pressure):
  Prain=10
  if (pressure < 1030):
    Prain = 20
  if (pressure < 1020):
    Prain = 30
  if (pressure < 1015):
    Prain = 40
  if (pressure < 1010):
    Prain = 50
  if (pressure < 1007):
    Prain = 60
  if (pressure < 1003):
    Prain = 70
  if (pressure < 1000):
    Prain = 80
  if (pressure < 990):
    Prain = 90
  return Prain

if __name__ == "__main__":
  taildata()
  graphs()
