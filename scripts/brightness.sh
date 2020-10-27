#!/bin/bash

current_brightnesses=($(xrandr --verbose | awk '/Brightness/ {printf "%s ", $2}'))
new_brightness=1

monitors=($(xrandr --listmonitors | awk '{printf "%s ", $4}'))
for i in ${!monitors[@]}
  do
    case $1 in
      inc)
        new_brightness=$(bc <<< "${current_brightnesses[$i]} + 0.1")
      ;;

      des)
        new_brightness=$(bc <<< "${current_brightnesses[$i]} - 0.1")
      ;;

      min)
        new_brightness=0
      ;;

      avg)
        new_brightness=1.0
      ;;
    esac
    # echo "new: $new_brightness,  current: ${current_brightnesses[$i]}, monit: ${monitors[$i]}"
    xrandr --output ${monitors[$i]} --brightness $new_brightness
done
