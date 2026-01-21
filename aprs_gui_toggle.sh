#!/bin/bash
set -e

PY="$HOME/aprs_map_gui.py"
PIDFILE="$HOME/.aprs_map_gui.pid"
URL="http://127.0.0.1:5000"

is_running() {
  if [[ -f "$PIDFILE" ]]; then
    pid="$(cat "$PIDFILE" 2>/dev/null || true)"
    [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null && return 0
  fi
  return 1
}

if is_running; then
  python3 "$PY" --stop || true
  notify-send "APRS Map GUI" "Stopped (RTL-SDR released)" 2>/dev/null || true
else
  python3 "$PY" --daemon
  notify-send "APRS Map GUI" "Started" 2>/dev/null || true
  (sleep 0.6; xdg-open "$URL" >/dev/null 2>&1) &
fi
