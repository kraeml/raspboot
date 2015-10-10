echo "Set permissions... [nut]"
sudo chmod 0640 /etc/nut/*

echo "Modifying installation..."
# Add user `pi` to the cups-related groups
sudo usermod -a -G lp,lpadmin pi
# mount /var/spool/cups on tmpfs
echo "tmpfs  /var/spool/cups  tmpfs  defaults,noatime,size=100M,mode=0755  0  0" | sudo tee -a /etc/fstab >/dev/null
echo "//rt-n66u.lan/pdf/      /media  cifs   rw,_netdev,username=scanner,password=scanner,gid=1000,uid=1000  0  0" | sudo tee -a /etc/fstab >/dev/null
