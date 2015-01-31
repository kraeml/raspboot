echo "Installing weather monitor packages..."
sudo apt-get -yuV install iw wireless-tools wpasupplicant
echo "Install Arduino support..."
sudo apt-get -yuV install arduino arduino-mk make
sudo apt-get install picocom python-dev python-setuptools
