# Stop XBMC to allow tinkering
echo "Stopping KODI ..."
sudo initctl stop xbmc
sudo initctl stop kodi
killem=$(ps aux|pgrep kodi)
echo "kodi PID = "$killem

echo "Installing packages..."
sudo apt-get update
sudo apt-get install rsync htop screen cron
