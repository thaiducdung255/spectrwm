DEVICE_ID=$(xinput | grep ^.*Touchpad | sed 's/.+id=//' | awk '{print $4, $5}' | sed 's/[a-zA-Z=\ \[]//g')
TAP_ENABLE_ID=$(xinput list-props $DEVICE_ID | grep Tapping\ Enabled\ \( | cut -d '(' -f 2 | cut -d ')' -f 1)
xinput set-prop $DEVICE_ID $TAP_ENABLE_ID 1
