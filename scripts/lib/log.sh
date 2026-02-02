#!/usr/bin/env bash

set -euo pipefail

KINDCTL_COLOR_RED='\033[0;31m'
KINDCTL_COLOR_GREEN='\033[0;32m'
KINDCTL_COLOR_YELLOW='\033[0;33m'
KINDCTL_COLOR_RESET='\033[0m'

kindctl_log() {
  local msg="${1:-}"
  printf "%b%s%b %s\n" "${KINDCTL_COLOR_GREEN}" "kindctl" "${KINDCTL_COLOR_RESET}" "${msg}"
}

kindctl_warn() {
  local msg="${1:-}"
  printf "%b%s%b %s\n" "${KINDCTL_COLOR_YELLOW}" "kindctl" "${KINDCTL_COLOR_RESET}" "${msg}" >&2
}

kindctl_err() {
  local msg="${1:-}"
  printf "%b%s%b %s\n" "${KINDCTL_COLOR_RED}" "kindctl" "${KINDCTL_COLOR_RESET}" "${msg}" >&2
}

kindctl_die() {
  kindctl_err "${1:-unknown error}"
  exit "${2:-1}"
}

kindctl_banner() {
  cat <<'EOF'
 _  _   _   ___   _____  _   _
| |/ / | | |_ _| |_   _|| | | |
| ' <  | |  | |    | |  | |_| |
| . \  | |__| |   _| |_ |  _  |
|_|\_\  \____/  |_____||_| |_|
EOF
}

