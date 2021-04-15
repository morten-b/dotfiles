set -x QT_STYLE_OVERRIDE adwaita-dark

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        sleep 1
        exec startx -- -keeptty
    end
end

