
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

echo "Installing WIFI support..."
install_package "wavemon"
install_package "usbutils"

echo "Installing additional packages..."
install_package "python3"
install_package "build-essential"
install_package "python3-dev"
install_package "python3-setuptools"
install_package "python3-rpi.gpio"
install_package "wiringpi"
gpio readall

install_package "rpi-update"
install_package "avahi-daemon"

install_package "graphviz"
