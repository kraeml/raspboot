#!/usr/bin/python
import serial, commands, sys
#var = 1
#line = "empty"
#ser = serial.Serial('/dev/ttyACM0', 9600, timeout=100)
#ser.close()

#ser.open()

#while (var == 1):
#  f = open('/tmp/workfile', 'a')
#  line = ser.readline()
#  print line
#  f.write(line)
#  ser.flush()
#  f.close()

#ser.close()

#get date/time
dt = commands.getoutput("date '+%F %H:%M:%S'")

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=5)

# get data
line = ser.readline()
ser.flush()
#discard the first line.
line = ser.readline()
ser.flush()
ser.close()

f = file('/tmp/testser.txt', 'a')
f.write('{0}, {1}'.format(dt, line))
#print '{0}, {1}'.format(dt, line)
f.close()
