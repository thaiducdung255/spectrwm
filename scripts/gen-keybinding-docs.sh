#!/bin/bash

cat ~/.config/.spectrwm/.spectrwm.conf | grep "bind\[" \
  | awk '{printf "%s ---------------------------------- %s\n", $1, $3}' \
  | tail -50 \
  > ~/.config/.spectrwm/docs/keybinding-last.doc

cat ~/.config/.spectrwm/.spectrwm.conf | grep "bind\[" \
  | awk '{printf "%s ---------------------------------- %s\n", $1, $3}' \
  | head -50 \
  > ~/.config/.spectrwm/docs/keybinding-first.doc

