echo "Modifying installation..."

# Enable 1-wire
sudo echo "w1-gpio pullup=1" >> /etc/modules
sudo echo "w1-therm"         >> /etc/modules
