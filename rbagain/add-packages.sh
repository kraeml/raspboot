#echo "Installing WIFI support..."
sudo apt-get -yuV install iw wireless-tools wpasupplicant

#echo "Installing Arduino support..."
#sudo apt-get -yuV install arduino

# make
# arduino-mk
#echo "Installing Serial Port package..."
#sudo apt-get -yuV install picocom
echo "Installing additional Python packages..."
#sudo apt-get -yuV install python-dev python-setuptools python-serial
#sudo apt-get -yuV install python-matplotlib python-bs4 python-lxml
sudo apt-get -yuV install python-mysqldb gnuplot gnuplot-nox mysql-client
