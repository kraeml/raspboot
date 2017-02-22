echo "Modifying installation..."

echo -n "Modify /boot/config.txt "
# Scaled CPU frequency
echo ""                         | sudo tee /boot/config.txt
echo "# Added by raspboot"      | sudo tee /boot/config.txt
echo "arm_freq=950"             | sudo tee /boot/config.txt
echo "core_freq=450"            | sudo tee /boot/config.txt
echo "sdram_freq=450"           | sudo tee /boot/config.txt
echo "over_voltage=6"           | sudo tee /boot/config.txt
echo ""                         | sudo tee /boot/config.txt
echo "arm_freq_min=500"         | sudo tee /boot/config.txt
echo "core_freq_min=250"        | sudo tee /boot/config.txt
echo "sdram_freq_min=400"       | sudo tee /boot/config.txt
echo "over_voltage_min=0"       | sudo tee /boot/config.txt
echo ""                         | sudo tee /boot/config.txt
echo "force_turbo=0"            | sudo tee /boot/config.txt
echo "temp_limit=70"            | sudo tee /boot/config.txt

echo "[OK]"
