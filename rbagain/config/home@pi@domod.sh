#!/bin/bash

# update the kernel to 4.4.8
# Linux rbian 4.4.8+ #880 Fri Apr 22 21:27:42 BST 2016 armv6l GNU/Linux
# tested stable commit:
# https://github.com/Hexxeh/rpi-firmware/commit/6d158adcc0cfa03afa17665715706e6e5f0750d2
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "% THIS WILL UPDATE THE KERNEL %"
echo "%       AND INSTALL DOMOD     %"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

pushd $HOME
  sudo rpi-update 6d158adcc0cfa03afa17665715706e6e5f0750d2

  sudo sed -i 's/kernel=/#kernel=/' /boot/config.txt
  sudo sed -i 's/initramfs/#initramfs/' /boot/config.txt
  echo 'dtoverlay=w1-gpio'  | sudo tee --append /boot/config.txt

  git clone https://github.com/Mausy5043/domod.git
  echo "v0" > "$HOME/.domod.branch"
  pushd domod
    ./install.sh
  popd
popd
