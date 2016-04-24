echo "Installing WIFI support..."
sudo apt-get -yuV install wavemon usbutils

echo "Installing additional Python packages..."
#sudo apt-get -yuV install python-dev python-setuptools python-serial
#sudo apt-get -yuV install python-matplotlib python-bs4 python-lxml
sudo apt-get -yuV install python-mysqldb gnuplot gnuplot-nox mysql-client
