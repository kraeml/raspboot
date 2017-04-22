echo "Modifying installation..."

echo "Modify /boot/config.txt "
# Scaled CPU frequency
echo ""                         | sudo tee -a /boot/config.txt
echo "# Added by raspboot"      | sudo tee -a /boot/config.txt
echo "arm_freq=950"             | sudo tee -a /boot/config.txt
echo "core_freq=450"            | sudo tee -a /boot/config.txt
echo "sdram_freq=450"           | sudo tee -a /boot/config.txt
echo "over_voltage=6"           | sudo tee -a /boot/config.txt
echo ""                         | sudo tee -a /boot/config.txt
echo "arm_freq_min=500"         | sudo tee -a /boot/config.txt
echo "core_freq_min=250"        | sudo tee -a /boot/config.txt
echo "sdram_freq_min=400"       | sudo tee -a /boot/config.txt
echo "over_voltage_min=0"       | sudo tee -a /boot/config.txt
echo ""                         | sudo tee -a /boot/config.txt
echo "force_turbo=0"            | sudo tee -a /boot/config.txt
echo "temp_limit=70"            | sudo tee -a /boot/config.txt
echo "[OK]"

echo "Add mountpoint for external HDD "
sudo mkdir -p /mnt/icybox
echo "/dev/sda1 /mnt/icybox ext4 defaults  0   2"       | sudo tee -a /etc/fstab

echo "[OK]"

deluged
sudo pkill deluged
rm -rf ~/.config/deluge
ln -s /mnt/icybox/.config/deluge/ ~/.config/deluge

# ref: http://dev.deluge-torrent.org/wiki/UserGuide/Service/systemd
sudo adduser --system  --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge deluge
sudo adduser pi deluge

sudo /etc/init.d/deluged stop
sudo rm /etc/init.d/deluged
sudo update-rc.d deluged remove

systemctl enable /etc/systemd/system/deluged.service
systemctl start deluged
systemctl status deluged

systemctl enable /etc/systemd/system/deluge-web.service
systemctl start deluge-web
systemctl status deluge-web

sudo mkdir -p /mnt/icybox/log/deluge
sudo chown -R deluge:deluge /mnt/icybox/deluge
sudo chmod -R 750 /mnt/icybox/deluge

systemctl restart deluged
systemctl restart deluge-web
