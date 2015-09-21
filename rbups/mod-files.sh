echo "Set permissions... [nut]"
sudo chmod 0640 /etc/nut/*

echo "Modifying installation..."
# Add user `pi` to the cups-related groups
sudo usermod -a -G lp,lpadmin pi
# mount /var/spool/cups on tmpfs
echo "tmpfs /var/spool/cups tmpfs   defaults,noatime,size=100M,mode=0755         0 0" | sudo tee -a /etc/fstab >/dev/null
echo "//10.0.1.24/storage/USB8GB-0A22-839C/pdf  /media  cifs  rw,_netdev,guest,uid=1000  0 0" | sudo tee -a /etc/fstab >/dev/null
