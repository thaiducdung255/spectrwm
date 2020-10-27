#!/bin/bash
function unmute() {
  amixer -q set Master unmute
  amixer -q set Headphone unmute
  amixer -q set Speaker unmute
}

function mute() {
  amixer -q set Master mute
}

unmuteVal=$(amixer get Master | grep "\[on\]" | wc -l)

if [ $unmuteVal -gt 0 ]
  then
    mute
  else
    unmute
fi
