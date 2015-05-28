#echo "Installing WIFI support..."
#sudo apt-get -yuV install iw wireless-tools wpasupplicant

echo "Installing Arduino support..."
sudo apt-get -yuV install arduino

# make
# arduino-mk
echo "Installing Serial Port package..."
sudo apt-get -yuV install picocom
echo "Installing additional Python packages..."
sudo apt-get -yuV python-dev python-setuptools python-serial
sudo apt-get -yuV install python-matplotlib python-bs4 python-lxml

# Retrieve and install Arduino support files
echo "Installing Arduino support..."
git clone https://github.com/Mausy5043/arduino.git
chmod -R 744 arduino/
pushd arduino/ino
  python setup.py
popd
