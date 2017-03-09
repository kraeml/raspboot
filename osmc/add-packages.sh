
install_package()
{
  # See if packages are installed and install them.
  package=$1
  echo "*********************************************************"
  echo "* Requesting $package"
  status=$(dpkg-query -W -f='${Status} ${Version}\n' $package 2>/dev/null | wc -l)
  if [ "$status" -eq 0 ]; then
    echo "* Installing $package"
    echo "*********************************************************"
    sudo apt-get -yuV install $package
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

# Stop XBMC to allow tinkering
echo "Stopping KODI ..."
sudo systemctl stop mediacenter

#killem=$(ps aux|pgrep kodi)
#echo "kodi PID = "$killem

echo "Installing packages..."
sudo apt-get update
install_package "bc"
install_package "rsync"
install_package "htop"
install_package "screen"
install_package "git"
install_package "cron"
install_package "wavemon"


install_package "graphviz"
