#!/bin/bash

monitor_index=$2
cmd=$1
monitors=($(xrandr --listmonitors | awk '{printf "%s ", $4}'))
current_brightnesses=($(xrandr --verbose | awk '/Brightness/ {printf "%s ", $2}'))
new_brightness=1

function set_new_brightness {
  case $1 in
    inc)
      new_brightness=$(bc <<< "${current_brightnesses[$2]} + 0.1")
    ;;

    des)
      new_brightness=$(bc <<< "${current_brightnesses[$2]} - 0.1")
    ;;

    min)
      new_brightness=0
    ;;

    avg)
      new_brightness=1.0
    ;;
  esac
}

if [ "$monitor_index" != "" ]
then
  # change brightness independently
  set_new_brightness $cmd $monitor_index
  xrandr --output ${monitors[$monitor_index]} --brightness $new_brightness
else
  # change brightness of all monitors
  for i in ${!monitors[@]}
    do
      set_new_brightness $cmd $i
      xrandr --output ${monitors[$i]} --brightness $new_brightness
  done
fi
