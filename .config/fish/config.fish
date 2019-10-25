# opam configuration
source /home/morten/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Start sway at login
if status is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
	export MOZ_ENABLE_WAYLAND=1
	export GTK_THEME=Arc-Dark-solid
	export _JAVA_AWT_WM_NONREPARENTING=1 idea
	export XDG_CURRENT_DESKTOP=Unity
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/morten/CompSys/x86prime/bin
	export TERM=xterm-256color
	export EDITOR=micro
    exec sway -d 2> ~/.sway.log
    end
end

