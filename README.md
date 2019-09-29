# Setup  
https://gist.github.com/mattiaslundberg/8620837

https://tutos.readthedocs.io/en/latest/source/Arch.html

## Firefox  
about:config new string with "widget.content.gtk-theme-override" name and content "Adwaita:light"   
Force tab: https://support.mozilla.org/en-US/questions/1193456  

### WebRTC disable   
about:config media.peerconnection.enabled set false  

## Fish default:  
chsh -s /usr/bin/fish   

## Disable speaker  
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf  

## Lock on lid close
See file under .config

## Natural scrolling
Add the following to /etc/X11/xorg.conf.d/30-touchpad.conf  
Option "NaturalScrolling" "true"  

## Autologin
systemctl edit getty@tty1

## and add:
[Service]
Type=simple
ExecStart=
ExecStart=-/usr/bin/agetty --autologin morten --noclear %I $TERM

#Sync clock
systemctl enable ntpdate.service

#Syncthing
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

#Fix clang in Code:
sudo ln -sf /usr/lib/libncursesw.so.6 /usr/lib/libtinfo.so.5

#Udiski2
systemctl enable udisks2
