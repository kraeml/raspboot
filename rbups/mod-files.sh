echo "Set permissions... [nut]"
sudo chmod 0640 /etc/nut/*

echo "Modifying installation..."
# Add user `pi` to the cups-related groups
sudo usermod -a -G lp,lpadmin pi
# mount /var/spool on tmpfs
echo "tmpfs /var/spool/cups tmpfs   defaults,noatime,size=100M,mode=0755         0 0" | sudo tee -a /etc/fstab >/dev/null

# Move `cron` logging to a separate file
sudo sed -i 's/auth\,authpriv\.none/cron\,auth\,authpriv\.none/' /etc/rsyslog.conf
sudo sed -i 's/\#cron/cron/' /etc/rsyslog.conf
