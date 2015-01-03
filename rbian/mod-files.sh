echo "Modifying installation..."
# Add user `pi` to the cups-related groups
sudo usermod -a -G lp,lpadmin pi
