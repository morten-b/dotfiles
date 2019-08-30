# Start sway at login
if status is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
	    export MOZ_ENABLE_WAYLAND=1
	    export QT_QPA_PLATFORMTHEME=qt5ct
	    export GTK_THEME=Arc-Dark-solid
	    export _JAVA_AWT_WM_NONREPARENTING=1 idea
	    export XDG_CURRENT_DESKTOP=Unity
        exec sway -d 2> ~/sway.log
    end
end
