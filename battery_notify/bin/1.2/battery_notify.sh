#!/bin/sh
# This script checks current battery charge percentage and triggers and audio alarm
# and sends desktop notification if the upper and lower limits are reached

user=$(whoami)
env_reference_process=$( pgrep -u "$user" xfce4-session || pgrep -u "$user" ciannamon-session || pgrep -u "$user" gnome-session || pgrep -u "$user" gnome-shell || pgrep -u "$user" kdeinit | head -1 )

export DBUS_SESSION_BUS_ADDRESS=$(cat /proc/"$env_reference_process"/environ | grep --null-data ^DBUS_SESSION_BUS_ADDRESS= | sed 's/DBUS_SESSION_BUS_ADDRESS=//')
export DISPLAY=$(cat /proc/"$env_reference_process"/environ | grep --null-data ^DISPLAY= | sed 's/DISPLAY=//')

MIN_BAT=20
MAX_BAT=80

UNPLUGGED=`/bin/cat /sys/bus/acpi/drivers/battery/*/power_supply/BAT?/status|grep -i discharging`
BAT_PERCENTAGE=`/usr/bin/acpi|grep -Po "[0-9]+(?=%)"`

if [ $BAT_PERCENTAGE -le $MIN_BAT ]; then # Battery under low limit
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/notify-send -u critical "Battery under $MIN_BAT. Please plug in the adapter"
elif [ $BAT_PERCENTAGE -ge $MAX_BAT ]; then # Battery over high limit
 if [ "$UNPLUGGED" == "" ]; then # plugged
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/notify-send -u critical "Battery above $MAX_BAT. Please remove the adapter"
 fi
fi


#Reference
#https://linoxide.com/linux-how-to/remind-unplug-charging-laptop-arch-linux/
#https://selivan.github.io/2016/07/08/notify-send-from-cron-in-ubuntu.html
