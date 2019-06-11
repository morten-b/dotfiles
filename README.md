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
https://wiki.archlinux.org/index.php/LightDM#Enabling_autologin

