echo "Modifying installation..."

sudo chown pi:pi /home/pi/domod.sh
chmod +x    /home/pi/domod.sh

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
  popd
popd

# SPI
