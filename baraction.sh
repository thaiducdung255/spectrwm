#!/bin/sh

print_batt() {
  BAT=""
  BAT_STATUS=$(acpitool | awk '/Battery/' | sed 's/^.*<//')

  if [ "$BAT_STATUS" = "not available>" ];
  then
    BAT="no batt"
  else
    BAT="batt"
  fi

  echo -n " <- Bat: ${BAT} -> "
}

print_cpu() {
  PERCENT_CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | cut -d '.' -f 1)
  echo -n " <- CPU: ${PERCENT_CPU}% -> "
}

print_uptime() {
  UP=$(uptime | awk '{printf " <- Uptime: %s %s -> ", $3, $4}' | sed 's/,//')
  echo -n "${UP}"
}

print_mem() {
  MEM=`/usr/bin/free -m | grep ^Mem | awk '{printf "%i", $3 / $2 * 100}'`
	echo -n " <- RAM: ${MEM}% -> "
}

print_bat() {
	AC_STATUS="$3"
	BAT_STATUS="$6"
	# Most battery statuses fit into a single word, except "Not charging"
	# for which we need to have special handling.
	if [ "$BAT_STATUS" = "  Not" ]; then
		BAT_STATUS="$BAT_STATUS $7"
		shift
	fi
	BAT_LEVEL="`echo "$7" | tr -d ','`"

	if [ "$AC_STATUS" != "" -o "$BAT_STATUS" != "" ]; then
		if [ "$BAT_STATUS" = "  Discharging," ]; then
			echo -n "<- On batt: $BAT_LEVEL -> "
		else
			case "$AC_STATUS" in
			on-line)
				AC_STRING=" <- On AC:"
				;;
			*)
				AC_STRING=" <- Batt:"
				;;
			esac
			case "$BAT_STATUS" in
			"")
				BAT_STRING="  (No batt) -> "
				;;
			*harging,|Full,)
				BAT_STRING=" $BAT_LEVEL -> "
				;;
			*)
				BAT_STRING=" unknown -> "
				;;
			esac

			FULL="${AC_STRING}${BAT_STRING}"
			if [ "$FULL" != "" ]; then
				echo -n "$FULL"
			fi
		fi
	fi
}

# Cache the output of acpi(8), no need to call that every second.
ACPI_DATA=""
I=0

while :; do
	if [ $I -eq 0 ]; then
		ACPI_DATA=`/usr/bin/acpi -a 2>/dev/null; /usr/bin/acpi -b 2>/dev/null`
	fi
	print_mem &
	print_cpu &
	# print_bat $ACPI_DATA &
  print_batt &
  print_uptime &
	echo ""
	I=$(( ( ${I} + 1 ) % 11 ))
	sleep 10
done
