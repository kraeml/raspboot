echo "Installing WIFI support..."
sudo apt-get -yuV install wavemon usbutils

echo "Installing additional packages..."
sudo apt-get -yuV install build-essential python-dev python-setuptools python-rpi.gpio
sudo apt-get -yuV install wiringpi
gpio readall

sudo apt-get -yuV install python-mysqldb gnuplot gnuplot-nox mysql-client

sudo apt-get -yuV install rpi-update avahi-daemon
