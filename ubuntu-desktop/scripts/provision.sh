apt-get update
apt-get upgrade -y


# switch to Turkish keyboard layout
sed -i 's/"us"/"tr"/g' /etc/default/keyboard
DEBIAN_FRONTEND=noninteractive apt-get install -y console-common
install-keymap tr

# set timezone to Turkey timezone
timedatectl set-timezone Europe/Istanbul

apt-get install --no-install-recommends ubuntu-desktop -y

DEBIAN_FRONTEND=noninteractive apt-get install libdvdnav4 libdvdread7 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvd-pkg ubuntu-restricted-extras firefox -y

# Enable autologin
sed -i "s/#  AutomaticLoginEnable/AutomaticLoginEnable/g" /etc/gdm3/custom.conf
sed -i "s/#  AutomaticLogin = user1/AutomaticLogin = vagrant/g" /etc/gdm3/custom.conf

echo "xrandr --output VGA-1 --mode 1680x1050" > /home/vagrant/.xinitrc
chown vagrant:vagrant /home/vagrant/.xinitrc

systemctl start gdm