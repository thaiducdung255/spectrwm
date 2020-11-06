#!/bin/sh

print_vol() {
  VOL_STATUS=$1
  VOL_LEVEL=$2
  case $VOL_STATUS in
    on)
      echo "+@fg=0;⊣ +@fg=3;Vol: +@fg=1;$2 +@fg=0;⊢"
      ;;
    off)
      echo "+@fg=0;⊣ +@fg=2;Vol: +@fg=1;$2 +@fg=0;⊢"
      ;;
  esac
}

print_batt() {
  CHARGE_STATUS="$4"
  PERCENT=$(echo $5 | sed 's/\..*/%/')
  TIME_LEFT=$(echo $6 | cut -d ':' -f 1,2)

  case $CHARGE_STATUS in
    Charging,)
      echo -n "+@fg=0;⊣ +@fg=3;Bat: +@fg=1;$PERCENT +@fg=0;[+@fg=1;$TIME_LEFT+@fg=0;] +@fg=0;⊢"
      ;;
    Discharging,)
      echo -n "+@fg=0;⊣ +@fg=2;Bat: +@fg=1;$PERCENT +@fg=0;[+@fg=1;$TIME_LEFT+@fg=0;] +@fg=0;⊢" 
      ;;
    Full,)
      echo -n "+@fg=0;⊣ +@fg=3;Bat: $PERCENT +@fg=0;⊢"
      ;;
  esac
}

print_cpu() {
  PERCENT_CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | cut -d '.' -f 1)
  echo -n "+@fg=0;⊣ +@fg=3;CPU: ${PERCENT_CPU}%+@fg=0; +@fg=0;⊢"
}

print_uptime() {
  UP=$(uptime | awk '{print $3, $4}' | sed 's/,//' | sed 's/\s[0-9]*//')
  echo -n "+@fg=0;⊣ +@fg=1;Up: ${UP}+@fg=0; +@fg=0;⊢"
}

print_mem() {
  MEM=`/usr/bin/free -m | grep ^Mem | awk '{printf "%i", $3 / $2 * 100}'`
  echo -n "+@fg=0;⊣ +@fg=1;RAM: ${MEM}%+@fg=0; +@fg=0;⊢"
}

SLEEP_SEC=5
while :; do
  VOL_CMD=`amixer get Master | awk -F'[][]' 'END{ print $6, $2 }'`

  echo "$(print_cpu &)\
$(print_mem &)\
$(print_batt `acpitool` &)\
$(print_uptime &)\
$(print_vol $VOL_CMD &)"

	sleep $SLEEP_SEC
done

