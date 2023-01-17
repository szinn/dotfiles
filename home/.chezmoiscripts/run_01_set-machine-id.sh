#!/bin/bash

# Set a machine_id.yaml file, setting the machine type.
# If MacOS, it pulls the Mac serial number.  If linux,
# it uses the /etc/machine-id value.
FILE="$HOME/.config/chezmoi/machine_id.yaml"
if [[ ! -f "$FILE" ]]; then
  if [[ $(command -v ioreg) ]]; then
    ID=$(ioreg -l | grep IOPlatformSerialNumber | awk '{ print $4; }' | tr -d '"')
  else
    ID=$(cat /etc/machine-id)
  fi
  mkdir -p $(dirname $FILE)
  echo "id: $ID" > "$FILE"
fi
