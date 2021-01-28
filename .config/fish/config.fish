set -x WLR_NO_HARDWARE_CURSORS 1
set -x MOZ_ENABLE_WAYLAND 1
set -x XDG_CURRENT_DESKTOP sway
set -x XDG_SESSION_TYPE wayland
set -x QT_STYLE_OVERRIDE adwaita-dark

# Start Sway at login
if test -z $DISPLAY; and test (tty) = "/dev/tty1"
    sway
end
