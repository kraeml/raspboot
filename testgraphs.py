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

def tailcorr():
  print "Tailing correlation-data"
  fin = headstails.FileExtremities('/tmp/corr.txt','r')
  # read last 1200 datapoints
  F = fin.tail(1200)

  fout = file('/tmp/corrdata.txt','w')
  for c in F:
    fout.write("%s" % (c) )
  fout.close()

def corrs():
  print "Loading correlation-data"
  C=np.loadtxt('/tmp/corrdata.txt',delimiter=',',converters={0:strpdate2num("%Y-%m-%d %H:%M:%S")})
  # 1 = ATMEGA vs DS18B20
  # 2 = DHT22 vs. DS18B20
  # 3 = TMP36 vs. DS18B20
  #
  # correlation coefficients a,b : f(x) =  a*x + b
  # r2 : R^2 of data to correlation coefs
  # 1,2,3 = a  (slope)
  # 4,5,6 = b  (offset)
  # 6,7,8 = r2 (R^2)

  A1 = C[:,1]
  A2 = C[:,2]
  A3 = C[:,3]
  B1 = C[:,4]
  B2 = C[:,5]
  B3 = C[:,6]
  R1 = C[:,7]
  R2 = C[:,8]
  R3 = C[:,9]

  D = matplotlib.dates.num2date(C[:,0])

  pl.close()
  print "corr.coef-a- trends"
  print ""
  pl.plot(D,A1, '.r', label='ATMEGA')
  pl.plot(D,A2, '.g', label='DHT22')
  pl.plot(D,A3, '.b', label='TMP36')
  pl.title('correlation trends slope (a)')
  pl.ylabel('a [-]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/corr-a.png')

  pl.close()
  print "corr.coef-b- trends"
  print ""
  pl.plot(D,B1, '.r', label='ATMEGA')
  pl.plot(D,B2, '.g', label='DHT22')
  pl.plot(D,B3, '.b', label='TMP36')
  pl.title('correlation trends offset (b)')
  pl.ylabel('b [-]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/corr-b.png')

  pl.close()
  print "corr.coef-R2- trends"
  print ""
  pl.plot(D,R1, '.r', label='ATMEGA')
  pl.plot(D,R2, '.g', label='DHT22')
  pl.plot(D,R3, '.b', label='TMP36')
  pl.title('correlation trends R^2 (r2)')
  pl.ylabel('r2 [-]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/corr-r.png')

  print "Ready..."

  return

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

  #A1 = C[:,1]
  #A1_extrema = [min(A1),max(A1)]
  A2 = C[:,2]
  #A2_extrema = [min(A2),max(A2)]
  A3 = C[:,3]
  #A3_extrema = [min(A3),max(A3)]
  A4 = C[:,4]
  #A4_extrema = [min(A4),max(A4)]
  A5 = C[:,5]
  #A5_extrema = [min(A5),max(A5)]
  A6 = C[:,6]
  A7 = C[:,7]
  A8 = C[:,8]
  A9 = C[:,9]
  #A9_extrema = [min(A9),max(A9)]
  A10 = C[:,10]
  A11 = C[:,11]
  A11_extrema = [min(A11),max(A11)]

  D = matplotlib.dates.num2date(C[:,0])

  pl.close()

  A32 = np.subtract(A3,A2)
  print "DHT22 vs. DS18B20"
  pl.plot(D,A32,'g.', label='DHT22  vs. DB18B20', alpha=0.7)
  A92 = np.subtract(A9,A2)
  print "TMP36 vs. DS18B20"
  pl.plot(D,A92,'b.', label='TMP36  vs. DS18B20', alpha=0.7)
  A112 = np.subtract(A11,A2)
  print "BMP183 vs. DS18B20"
  pl.plot(D,A112,'m.', label='BMP183 vs. DS18B20', alpha=0.7)

  #print "Sensor correlations graph"
  print "Sensor differences graph"
  print ""
  pl.title('Sensor differences')
  pl.ylabel("T(x)-T(DS18B20) [degC]")
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/C123.png')


  ab = np.polyfit(A11,A2,1)
  fit = np.poly1d(ab)
  r2 = np.corrcoef(A11,A2)[0,1]
  print "BMP183 vs DS18B20"
  print ab[0], ab[1], r2
  print ""
  pl.close()
  pl.plot(A11,A2,'m.')
  pl.plot(A11_extrema,fit(A11_extrema),'b-')
  pl.title('BMP183 vs. DS18B20')
  pl.xlabel("T(BMP183) [degC]")
  pl.ylabel("T(DS18B20) [degC]")
  pl.annotate('{0}'.format(r2) , xy=(min(A11)+0.5,fit(min(A11))), size=6 )
  pl.grid(True)
  pl.savefig('/tmp/C56.png')

  pl.close()
  print "Temperature trends"
  print ""
  pl.plot(D,A2, '.y', label='DS18B20')
  pl.plot(D,A3, '.g', label='DHT22')
  pl.plot(D,A9, '.b', label='TMP36')
  pl.plot(D,A11, '.m', label='BMP183')
  pl.title('Temperature trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D123.png')

  pl.close()
  print "Relative humidity trend"
  print ""
  pl.plot(D,A4,'.b')
  pl.title('Relative humidity trend')
  pl.ylabel('RH [%]')
  pl.grid(True)
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D4.png')

  pl.close()
  print "Dewpoint trends"
  print""
  pl.plot(D,A5,'.r', label='DP1')
  pl.plot(D,A6,'.b', label='DP2')
  pl.title('Dewpoint trends')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D56.png')

  pl.close()
  print "Temperature trends"
  print ""
  pl.plot(D,A2, '.y', label='Temperature')
  pl.plot(D,A7,'.r', label='Heat Index')
  pl.plot(D,A6,'.b', label='DewPoint')
  pl.title('Temperature')
  pl.ylabel('T [degC]')
  pl.grid(True)
  pl.annotate('Text' , xy=(0.1, 0.5), xycoords='axes fraction', size=16 )
  pl.legend(loc='upper left', prop={'size':8})
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D7.png')

  pl.close()
  print "Solar charger trend"
  print""
  pl.plot(D,A8,'.b')
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
  Ptrend = "{0:.1f}".format(A10[lenD-1])

  if ( lenD > L1 ):
    delta1 = float(A10[lenD-1] - A10[lenD-1-L1])
    if ((delta1 <= 0.15) & (delta1 >= -0.15)):
      Tr1=u'\u21D2'
    if (delta1 > 0.15):
      Tr1=u'\u21D7'
    if (delta1 < -0.15):
      Tr1=u'\u21D8'

  Ptrend = Ptrend + " | " + "{0:.2f}".format(delta1) + ":" + Tr1
  Prain = int(-0.0231 * A10[lenD -1] + 23.612)
  Ptrend = "Neerslagkans: {0}% \n".format(Prain)

  if ( lenD > L3 ):
    delta3 = float(A10[lenD-1] - A10[lenD-1-L3])
    if ((delta3 <= 0.20) & (delta3 >= -0.20)):
      Tr3=u'\u21D2'
    if (delta3 > 0.20):
      Tr3=u'\u21D7'
    if (delta3 < -0.20):
      Tr3=u'\u21D8'

  Ptrend = Ptrend + " | " + "{0:.2f}".format(delta3) + ":" + Tr3

  pl.close()
  print "Pressure trend"
  print""
  pl.plot(D,A10,'.b')
  pl.title('Pressure trend')
  pl.ylabel('Pressure [mbara]')
  pl.grid(True)
  # SyntaxError: Non-ASCII character '\xe2' in file /home/pi/gitbin/testgraphs.py
  # on line 244, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details
  # Charactercodes: http://www.fileformat.info/info/unicode/block/arrows/utf8test.htm
  pl.annotate(Ptrend , xy=(0.1, 0.5), xycoords='axes fraction', size=12 )
  pl.gcf().autofmt_xdate()
  pl.savefig('/tmp/D11.png')

  return

if __name__ == "__main__":
  taildata()
  graphs()
