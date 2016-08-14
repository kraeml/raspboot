#!/bin/bash

# update the kernel

# tested stable commits:
# Linux rbian 4.4.8+ #880 Fri Apr 22 21:27:42 BST 2016 armv6l GNU/Linux
# https://github.com/Hexxeh/rpi-firmware/commit/6d158adcc0cfa03afa17665715706e6e5f0750d2
#
# Linux rbagain 4.4.11+ #886 Thu May 19 15:14:34 BST 2016 armv6l GNU/Linux
# https://github.com/Hexxeh/rpi-firmware/commit/48cfa89779408ecd69db4eb793b846fb7fe40c4b

echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "% THIS WILL UPDATE THE KERNEL %"
echo "%       AND INSTALL DOMOD     %"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

pushd $HOME
  sudo rpi-update 48cfa89779408ecd69db4eb793b846fb7fe40c4b

  sudo sed -i 's/kernel=/#kernel=/' /boot/config.txt
  sudo sed -i 's/initramfs/#initramfs/' /boot/config.txt
  echo 'dtoverlay=w1-gpio'  | sudo tee --append /boot/config.txt

  git clone https://github.com/Mausy5043/domod.git
  echo "v3" > "$HOME/.domod.branch"
  pushd domod
    ./install.sh
  popd
popd
