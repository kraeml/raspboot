echo "Modifying installation..."

# Enable 1-wire
# ref: http://domoticx.com/raspberry-pi-temperatuur-sensor-ds18b20-uitlezen/
sudo echo "w1-gpio pullup=1" >> /etc/modules
sudo echo "w1-therm"         >> /etc/modules

echo "Installing Adafruit's DHT library..."
# ref: http://domoticx.com/python-library-dht-sensors/
# ref: http://domoticx.com/raspberry-pi-temp-en-luchtvochtigheid-sensor-dht11/
pushd /usr/src/
  sudo git clone https://github.com/adafruit/Adafruit_Python_DHT.git
  pushd Adafruit_Python_DHT
    sudo python setup.py install
  popd
popd

# GPIO ref: https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-gpio
#           https://www.raspberrypi.org/documentation/usage/gpio/README.md

# SPI
