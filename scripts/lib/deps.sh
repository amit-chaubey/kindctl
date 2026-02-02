#!/usr/bin/env bash

set -euo pipefail

kindctl_require_cmd() {
  local cmd="$1"
  command -v "${cmd}" >/dev/null 2>&1 || kindctl_die "Missing dependency: '${cmd}'. Install it and retry."
}

kindctl_require_docker() {
  kindctl_require_cmd docker
  docker info >/dev/null 2>&1 || kindctl_die "Docker is not running or not reachable. Start Docker Desktop and retry."
}

kindctl_require_kind() {
  kindctl_require_cmd kind
}

kindctl_require_kubectl() {
  kindctl_require_cmd kubectl
}

