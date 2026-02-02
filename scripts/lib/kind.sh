#!/usr/bin/env bash

set -euo pipefail

kindctl_default_config_path() {
  echo "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/kind/cluster.yaml"
}

kindctl_kubeconfig_path_for() {
  local cluster_name="$1"
  local repo_root
  repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  echo "${repo_root}/.kube/kubeconfig-${cluster_name}"
}

kindctl_kind_up() {
  local cluster_name="$1"
  local config_path="$2"
  local kubeconfig_path="$3"

  mkdir -p "$(dirname "${kubeconfig_path}")"

  kindctl_log "Creating kind cluster '${cluster_name}'"
  kind create cluster \
    --name "${cluster_name}" \
    --config "${config_path}" \
    --kubeconfig "${kubeconfig_path}"

  kindctl_log "Kubeconfig written to: ${kubeconfig_path}"
  kindctl_log "Validating cluster access"
  KUBECONFIG="${kubeconfig_path}" kubectl cluster-info >/dev/null
}

kindctl_kind_down() {
  local cluster_name="$1"
  local kubeconfig_path="$2"

  kindctl_log "Deleting kind cluster '${cluster_name}'"
  kind delete cluster --name "${cluster_name}" >/dev/null || true

  if [[ -f "${kubeconfig_path}" ]]; then
    kindctl_log "Removing kubeconfig: ${kubeconfig_path}"
    rm -f "${kubeconfig_path}"
  fi
}

kindctl_kind_status() {
  local cluster_name="$1"
  local kubeconfig_path="$2"

  local found="false"
  local c
  while IFS= read -r c; do
    [[ -z "${c}" ]] && continue
    if [[ "${c}" == "${cluster_name}" ]]; then
      found="true"
      break
    fi
  done < <(kind get clusters)

  if [[ "${found}" == "true" ]]; then
    kindctl_log "Cluster '${cluster_name}' exists"
  else
    kindctl_log "Cluster '${cluster_name}' does not exist"
    return 1
  fi

  if [[ -f "${kubeconfig_path}" ]]; then
    kindctl_log "Using kubeconfig: ${kubeconfig_path}"
    KUBECONFIG="${kubeconfig_path}" kubectl get nodes -o wide
  else
    kindctl_log "Fetching kubeconfig from kind into ${kubeconfig_path}"
    mkdir -p "$(dirname "${kubeconfig_path}")"
    kind get kubeconfig --name "${cluster_name}" > "${kubeconfig_path}"
    kindctl_log "Using kubeconfig: ${kubeconfig_path}"
    KUBECONFIG="${kubeconfig_path}" kubectl get nodes -o wide
  fi
}

kindctl_kind_nodes() {
  local cluster_name="$1"
  kind get nodes --name "${cluster_name}"
}

