echo "Modifying installation..."

# Enable 1-wire
echo "Installing 1-wire support..."
# ref: http://domoticx.com/raspberry-pi-temperatuur-sensor-ds18b20-uitlezen/
# quick check: cat /sys/bus/w1/devices/28-*/w1_slave
#echo "w1-gpio pullup=1"  | sudo tee --append /etc/modules
#echo "w1-therm"          | sudo tee --append /etc/modules

# GPIO ref: https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-gpio
#           https://www.raspberrypi.org/documentation/usage/gpio/README.md
#           http://abyz.co.uk/rpi/pigpio/index.html
echo "Building pigpio..."
pushd /usr/src
  sudo git clone https://github.com/joan2937/pigpio
  pushd pigpio
    sudo make -j4
    sudo make install
    sudo ./x_pigpio
  popd
popd

# SPI

# update the kernel to 4.4.8
# Linux rbian 4.4.8+ #880 Fri Apr 22 21:27:42 BST 2016 armv6l GNU/Linux
# tested stable commit:
# https://github.com/Hexxeh/rpi-firmware/commit/6d158adcc0cfa03afa17665715706e6e5f0750d2
sudo rpi-update 6d158adcc0cfa03afa17665715706e6e5f0750d2

sudo sed -i 's/kernel=/#kernel=/' /boot/config.txt
sudo sed -i 's/initramfs/#initramfs/' /boot/config.txt
echo 'dtoverlay=w1-gpio'  | sudo tee --append /boot/config.txt
