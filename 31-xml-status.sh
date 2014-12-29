#! /bin/bash

xml=/tmp/gitbin/status.xml

#raspberry
echo "  <server>" > $xml
echo "    <name>" >> $xml
hostname >> $xml
echo "    </name>" >> $xml
echo "    <df>" >> $xml
df -h >> $xml
echo "    </df>" >> $xml
echo "    <temperature>" >> $xml
/opt/vc/bin/vcgencmd measure_temp >> $xml
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq >> $xml
echo "    </temperature>" >> $xml
echo "    <memusage>" >> $xml
free -h >> $xml
echo "    </memusage>" >> $xml
echo "    <uptime>" >> $xml
uptime >> $xml
uname -a >> $xml
ps -e -o pcpu,args | awk 'NR>2' | sort -nr | head -6 | sed 's/&/\&amp;/g' | sed 's/>/\&gt;/g'>> $xml
echo "    </uptime>" >> $xml
echo "  </server>" >> $xml
