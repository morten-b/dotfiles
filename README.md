# Setup  
https://gist.github.com/mattiaslundberg/8620837
https://tutos.readthedocs.io/en/latest/source/Arch.html

## Remove  


## Install  
fish git keepassxc base-devel vlc gnome-calculator gimp zathura micro zathura-pdf-mupdf udiskie arc-solid-gtk-theme lxappearance qt5ct kvantum-qt5 udisks2 python-gobject python-setuptools python-docopt gtk3 libnotify gettext python-keyutils keyutils python-yaml xfce4-notifyd feh compton xfce4-screenshooter xorg-xrandr arandr

## Install from AUR  
standardnotes-desktop signal yadm-git micro

## Firefox  
about:config new string with "widget.content.gtk-theme-override" name and content "Adwaita:light"   
Force tab: https://support.mozilla.org/en-US/questions/1193456  

### WebRTC disable   
about:config media.peerconnection.enabled set false  

## Fish default:  
chsh -s /usr/bin/fish   

## Disable speaker  
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf  

## Mullvad DNS (MANGLER)
Tilføj til /etc/resolv.conf.head
#Mullvad DNS  
nameserver 193.138.218.74
nameserver 10.8.0.1

## Lock on lid close
See file under .config

## Setup SSH with github

## Natural scrolling
Add the following to /etc/X11/xorg.conf.d/30-touchpad.conf  
Option "NaturalScrolling" "true"  

## Autologin
https://wiki.archlinux.org/index.php/LightDM#Enabling_autologin

