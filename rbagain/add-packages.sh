echo "Installing WIFI support..."
sudo apt-get -yuV install wavemon usbutils

echo "Installing additional packages..."
sudo apt-get -yuV install python3 build-essential python3-dev python3-setuptools python3-rpi.gpio
sudo apt-get -yuV install wiringpi
gpio readall

sudo apt-get -yuV install rpi-update avahi-daemon
