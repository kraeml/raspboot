echo "Modifying installation..."

# Move `cron` logging to a separate file
sudo sed -i 's/auth\,authpriv\.none/cron\,auth\,authpriv\.none/' /etc/rsyslog.conf
sudo sed -i 's/\#cron/cron/' /etc/rsyslog.conf
