# Stop XBMC to allow tinkering
echo "Stopping KODI ..."
sudo systemctl stop mediacenter

#killem=$(ps aux|pgrep kodi)
#echo "kodi PID = "$killem

echo "Installing packages..."
sudo apt-get update
sudo apt-get -yuV install bc rsync htop screen git cron wireless-tools wavemon usbutils
sudo apt-get -yuV install python-mysqldb gnuplot gnuplot-nox mysql-client
sudo apt-get -yuV install lftp
