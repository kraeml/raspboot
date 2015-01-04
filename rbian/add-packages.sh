echo "Installing extra packages..."
sudo apt-get -yuV install cups hplip-cups openprinting-ppds
echo "Pausing... (1/3) "
sleep 60
sudo apt-get -yuV install cups-pdf cups-driver-gutenprint
echo "Pausing... (2/3) "
sleep 60
sudo apt-get -yuV install python-cups python-daemon python-pkg-resources
echo "Pausing... (3/3)"
sleep 60
