echo "Modifying installation..."
# Add user `pi` to the cups-related groups
usermod -a -G lp,lpadmin pi
