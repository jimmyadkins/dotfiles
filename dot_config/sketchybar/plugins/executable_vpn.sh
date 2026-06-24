#!/bin/bash

# Tailscale status indicator.
# sketchybar's PATH is minimal, so locate the CLI explicitly.
TAILSCALE=""
for candidate in /opt/homebrew/bin/tailscale /usr/local/bin/tailscale /Applications/Tailscale.app/Contents/MacOS/Tailscale; do
  if [[ -x "$candidate" ]]; then
    TAILSCALE="$candidate"
    break
  fi
done

# BackendState is a single top-level field: Running, Stopped, NeedsLogin, NoState...
BACKEND_STATE=""
if [[ -n "$TAILSCALE" ]]; then
  BACKEND_STATE=$("$TAILSCALE" status --json 2>/dev/null \
    | grep -o '"BackendState"[^,]*' \
    | head -n 1 \
    | sed -E 's/.*: *"([^"]*)".*/\1/')
fi

if [[ "$BACKEND_STATE" == "Running" ]]; then
  # Connected to the tailnet
  ICON="󰦝"  # VPN connected icon
  LABEL="Tailscale"
else
  # Stopped, NeedsLogin, not installed, or daemon unreachable
  ICON="󰦜"  # VPN disconnected icon
  LABEL=""
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
