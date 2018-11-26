#! /bin/bash
# This script checks current battery charge percentage and triggers and audio alarm
# and sends desktop notification if the upper and lower limits are reached

MIN_BAT=25
MAX_BAT=80

while :
do

UNPLUGGED=`/bin/cat /sys/bus/acpi/drivers/battery/*/power_supply/BAT?/status|grep -i discharging`
BAT_PERCENTAGE=`/usr/bin/acpi|grep -Po "[0-9]+(?=%)"`

if [ $BAT_PERCENTAGE -le $MIN_BAT ]; then # Battery under low limit
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-12.wav
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-12.wav
 /usr/bin/notify-send -u critical "Battery under $MIN_BAT. Please plug in the adapter"
elif [ $BAT_PERCENTAGE -ge $MAX_BAT ]; then # Battery over high limit
 if [ "$UNPLUGGED" == "" ]; then # plugged
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/paplay /usr/share/sounds/sound-icons/guitar-13.wav
 /usr/bin/notify-send -u critical "Battery above $MAX_BAT. Please remove the adapter"
 fi
fi

 sleep 10m # check every 10 minutes

done

#Reference
#https://linoxide.com/linux-how-to/remind-unplug-charging-laptop-arch-linux/
