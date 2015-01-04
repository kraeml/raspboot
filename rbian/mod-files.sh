echo "Modifying installation..."
# Add user `pi` to the cups-related groups
sudo usermod -a -G lp,lpadmin pi
# mount /var/spool on tmpfs
echo "tmpfs /var/spool/cups tmpfs   defaults,noatime,size=100M,mode=0755         0 0" | sudo tee -a /etc/fstab >/dev/null

# sudo service cups restart
