echo "Modifying installation..."
echo "Cloning KAMSTRUPd..."
git clone -b master https://github.com/Mausy5043/kamstrupd.git
# set permissions
chmod -R 0755 $HOME/kamstrupd
pushd $HOME/kamstrupd
  ./install.sh
popd
