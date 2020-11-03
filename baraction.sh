#!/bin/sh

print_batt() {
  CHARGE_STATUS="$4"
  PERCENT=$(echo $5 | sed 's/\..*/%/')
  TIME_LEFT=$(echo $6 | cut -d ':' -f 1,2)

  case $CHARGE_STATUS in
    Charging,)
      echo -n "⊣ Bat°: $PERCENT [$TIME_LEFT] ⊢"
      ;;
    Discharging,)
      echo -n "⊣ Bat: $PERCENT [$TIME_LEFT] ⊢"
      ;;
    Full,)
      echo -n "⊣ Bat°: $PERCENT ⊢"
      ;;
    # *)
    #   echo -n "⊣ No bat ⊢"
    #   ;;
  esac
}

print_cpu() {
  PERCENT_CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | cut -d '.' -f 1)
  echo -n "⊣ CPU: ${PERCENT_CPU}% ⊢"
}

print_uptime() {
  UP=$(uptime | awk '{print $3, $4}' | sed 's/,//' | sed 's/\s[0-9]*//')
  echo -n "⊣ Up: ${UP} ⊢"
}

print_mem() {
  MEM=`/usr/bin/free -m | grep ^Mem | awk '{printf "%i", $3 / $2 * 100}'`
  echo -n "⊣ RAM: ${MEM}% ⊢"
}

while :; do
  print_mem &
  print_cpu &
  print_batt `acpitool` &
  print_uptime &
  echo ""
  sleep 300
done
