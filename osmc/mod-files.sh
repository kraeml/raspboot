# `rxbmc` requires more set-up because it is not spawned from raspbian-ua-netinst

echo "Removing AVAHI services we don't offer..."
sudo rm /etc/avahi/services/sftp.service

# Create mountpoints
echo "Creating mountpoints ..."
sudo mkdir /mnt/backup
sudo mkdir /mnt/share1
mkdir etc

# Add mountpoints to /etc/fstab
echo "Adding mountpoints to /etc/fstab ..."
echo '# mountpoint for NFS on /media'  | sudo tee --append /etc/fstab
echo '10.0.1.220:/srv/array1/video  /media  nfs4  nouser,atime,auto,rw,dev,exec,suid  0 0'  | sudo tee --append /etc/fstab
echo '# mountpoint for systemlogs and backups'  | sudo tee --append /etc/fstab
echo '10.0.1.220:/srv/array1/backup /mnt/backup nfs4  nouser,atime,rw,dev,exec,suid,noauto 0 0'  | sudo tee --append /etc/fstab
echo 'tmpfs /tmp  tmpfs nodev,nosuid,size=64M,mode=1777 0 0'  | sudo tee --append /etc/fstab
echo 'tmpfs /var/log  tmpfs defaults,noatime,nosuid,mode=0755,size=96M  0 0'  | sudo tee --append /etc/fstab

# Mount networkdisk
echo "Restoring from backup ..."
echo -n "Mount - "
sudo mount /mnt/backup

if [ -e ~/.kodi ]; then
  echo -n "Move existing .kodi folder - "
  mv ~/.kodi ~/.kodi-org
fi

#echo -n "Restore bin - "
#cp -r /mnt/backup/osmc/home/osmc/bin/* ~/bin/
# set flag for raspboot
echo master > /home/osmc/.raspboot.branch

echo -n "Restore etc - "
cp -r /mnt/backup/osmc/home/osmc/etc/* ~/etc/

# Note: cronjobs may not start until after the reboot!
sudo crontab -u osmc .crntb

echo -n "Restore invisibles - "
cp /mnt/backup/osmc/home/osmc/.* ~/ 2>/dev/null
