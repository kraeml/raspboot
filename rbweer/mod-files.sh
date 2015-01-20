echo "Modifying installation..."

# Move `cron` logging to a separate file
sudo sed -i 's/auth\,authpriv\.none/cron\,auth\,authpriv\.none/' /etc/rsyslog.conf
sudo sed -i 's/\#cron/cron/' /etc/rsyslog.conf

# files to be changed
#/etc/networking/interfaces
# + allow-hotplug wlan0
# + iface wlan0 inet manual
# + wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
# + iface default inet dhcp

#/etc/wpa_supplicant/wpa_supplicant.conf
# + ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
# + update_config=1
# +
# + network={
# +  ssid="..."
# +  psk="..."
# +  key_mgmt=WPA-PSK
# +}
