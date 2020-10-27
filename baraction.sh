#!/bin/bash
# baraction.sh for spectrwm status bar

## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $5}')"
  echo -e "Disk: $hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%d%c", $3 / $2 * 100, "%"}'`
  echo -e "RAM: $mem"
}

## Battery
batt() {
  batt=`acpitool | awk '/Battery/ {printf "%s (%s)", $5, $4}' | sed 's/,//g' | sed 's/\.[0-9]*//'`
  echo -e "Bat: $batt"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "CPU: $cpu%"
}

## VOLUME
vol() {
    vol=`amixer get Master | awk -F'[][]' 'END{ print $2 }'`
    echo -e "Vol: $vol"
}

## Brightness
bri() {
  bri=`xrandr --verbose | grep "Brightness" | sed 's/Brightness:\s//' | awk '{printf "%d%c", $1 / 1.5 * 100, "%"}'`
  echo -e "Bri: $bri"
}

SLEEP_SEC=15

# It seems that we are limited to how many characters can be displayed via
# the baraction script output. And the the markup tags count in that limit.
# So I would love to add more functions to this script but it makes the 
# echo output too long to display correctly.
while :; do
    echo "+@fg=1; +@fn=1;+@fn=0; $(cpu) +@fg=0; | +@fg=2; +@fn=1;+@fn=0; $(mem) +@fg=0; | +@fg=3; +@fn=1;+@fn=0; $(hdd) +@fg=0; | +@fg=2; +@fn=1;+@fn=0; $(batt) +@fg=0; |"
	sleep $SLEEP_SEC
done
