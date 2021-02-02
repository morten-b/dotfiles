set -x QT_STYLE_OVERRIDE adwaita-dark

# Start i3 at login
if status is-login
    if test -z $DISPLAY; and test (tty) = "/dev/tty1"
        #exec startx -- -keeptty
    end
end

# Start Sway at login
if test -z $DISPLAY; and test (tty) = "/dev/tty2"
    set -x WLR_NO_HARDWARE_CURSORS 1
    set -x MOZ_ENABLE_WAYLAND 1
    set -x XDG_CURRENT_DESKTOP sway
    set -x XDG_SESSION_TYPE wayland
    sway
end

#if status is-login
#    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#        exec startx -- -keeptty
#    end
#end
