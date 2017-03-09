
install_package()
{
  # See if packages are installed and install them.
  package=$1
  echo "*********************************************************"
  echo "* Requesting $package"
  status=$(dpkg-query -W -f='${Status} ${Version}\n' $package 2>/dev/null | wc -l)
  if [ "$status" -eq 0 ]; then
    echo "* Installing $package"
    echo "*********************************************************"
    sudo apt-get -yuV install $package
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

echo "Installing additional Python packages..."
install_package "graphviz"
#sudo apt-get -yuV install python-dev python-setuptools python-serial
#sudo apt-get -yuV install python-matplotlib python-bs4 python-lxml
#echo "Switching to the RPF-kernel"
#sudo apt-get -yuV remove raspberrypi-bootloader-nokernel
#sudo apt-get -yuV install raspberrypi-bootloader libraspberrypi0 libraspberrypi-bin
