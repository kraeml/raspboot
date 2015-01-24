echo "Modifying installation..."

# Move `cron` logging to a separate file
sudo sed -i 's/auth\,authpriv\.none/cron\,auth\,authpriv\.none/' /etc/rsyslog.conf
sudo sed -i 's/\#cron/cron/' /etc/rsyslog.conf

# Install information about the wifi-network
sudo cp /home/pi/bin/wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf

# http://raspberrypi.stackexchange.com/questions/15153/i-get-wifi-timouts-with-the-rt2800usb-driver

# apt/sources.list add: non-free
