#!/bin/bash

power_off=" Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"
log_out=" Logout"

options="$power_off\n$reboot\n$lock\n$suspend\n$log_out"

chosen="$(echo -e "$options" | rofi -lines 5 -dmenu)"

case $chosen in
    $power_off)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        loginctl lock-session
        ;;
    $suspend)
        systemctl suspend
        ;;
    $log_out)
        i3-msg exit
        ;;
esac
