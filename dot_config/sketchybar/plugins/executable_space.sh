#!/bin/sh

# Desktop indicator: highlight the focused desktop and dim desktops with no
# windows. sketchybar sets $SELECTED for space items; space_windows_change is
# broadcast to every space item with {"space": N, "apps": {...}} in $INFO.

SID="${NAME#space.}"

if [ "$SENDER" = "space_windows_change" ]; then
  [ "$(printf '%s' "$INFO" | jq -r '.space')" = "$SID" ] || exit 0
  if [ "$(printf '%s' "$INFO" | jq '.apps | length')" -gt 0 ]; then
    sketchybar --set "$NAME" label.color=0xffffffff
  else
    sketchybar --set "$NAME" label.color=0x66ffffff
  fi
  exit 0
fi

sketchybar --set "$NAME" background.drawing="$SELECTED"
