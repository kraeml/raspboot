#!/usr/bin/env python

# Based on previous work by
# Charles Menguy (see: http://stackoverflow.com/questions/10217067/implementing-a-full-python-unix-style-daemon-process)
# and Sander Marechal (see: http://www.jejik.com/articles/2007/02/a_simple_unix_linux_daemon_in_python/)

# Adapted by M.Hendrix [2015]

import sys, time, math
from libdaemon import Daemon

class MyDaemon(Daemon):
	def run(self):
		cnt=0
		limit=3
		cycleTime = 12
		while True:
			startTime=time.time()

			do_work()

			# Measure and print the elapsed time
			#count = find_primes(limit)

			#elapsedTime=time.time()-startTime
			#f=file('/tmp/testd','a')
			#f.write('{0}, {1}, {2}, {3}, {4}\n'.format(cnt, limit, startTime, elapsedTime, count))
			#f.close
			#cnt = cnt + 1
			#limit=limit + 100

			waitTime = cycleTime - (time.time() - startTime) - (startTime%cycleTime)
			while waitTime <= 0:
				waitTime = waitTime + cycleTime

			time.sleep(waitTime)

def do_work():
	# Read the CPU temperature
	outTemp = commands.getoutput("cat /sys/class/thermal/thermal_zone0/temp")
	if float(outTemp) > 75000:
	  # can't believe my sensors. Probably a glitch. Wait a while then measure again
	  time.sleep(7)
	  outTemp = commands.getoutput("cat /sys/class/thermal/thermal_zone0/temp")
	  outTemp = float(outTemp) + 0.1

	# Get the time and date in human-readable form...
	outDate = commands.getoutput("date '+%F %H:%M:%S'")
	# ... and machine-readable form (UNIX-epoch)
	outUxDate = commands.getoutput("date +%s")


	# Define output file
	f = file('/tmp/11-t-cpu.txt', 'a')
	# Print the data
	f.write('{0}, {1}, {2}\n'.format(outDate, outUxDate, float(float(outTemp)/1000)) )
	# Close the file
	f.close()

	return

# Function to search for prime numbers
# within number range
def find_primes(upper_limit):
  count = 0
  candidate = 3
  while(candidate <= upper_limit):
    trial_divisor = 2
    prime = 1 # assume it's prime
    while(trial_divisor**2 <= candidate and prime):
      if(candidate%trial_divisor == 0):
        prime = 0 # it isn't prime
      trial_divisor+=1
    if(prime):
      #print_prime(candidate)
      count += 1
    candidate += 2
  return count

if __name__ == "__main__":
	daemon = MyDaemon('/tmp/daemon-example.pid')
	if len(sys.argv) == 2:
		if 'start' == sys.argv[1]:
			daemon.start()
		elif 'stop' == sys.argv[1]:
			daemon.stop()
		elif 'restart' == sys.argv[1]:
			daemon.restart()
		elif 'foreground' == sys.argv[1]:
			# assist with debugging.
			print "Debug-mode started. Use <Ctrl>+C to stop."
			daemon.run()
		else:
			print "Unknown command"
			sys.exit(2)
		sys.exit(0)
	else:
		print "usage: %s start|stop|restart|foreground" % sys.argv[0]
		sys.exit(2)
