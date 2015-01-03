echo "Installing extra packages..."
sudo apt-get -yuV install cups cups-pdf cups-driver-gutenprint hplip-cups
echo "Pausing..."
sleep 60
sudo apt-get -yuV install openprinting-ppds python-cups python-daemon python-pkg-resources
echo "Done..."
sleep 60
