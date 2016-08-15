echo "Set permissions... [nut]"
sudo chmod 0640 /etc/nut/*

echo "UPS monitor installation..."
git clone -b master https://github.com/Mausy5043/upsdiagd.git $HOME/upsdiagd
# set permissions
chmod -R 0755 $HOME/upsdiagd
pushd $HOME/upsdiagd
  ./install.sh
popd
