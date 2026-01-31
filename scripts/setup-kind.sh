#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME=${1:-kind}

if ! command -v kind >/dev/null 2>&1; then
  echo "kind is not installed" >&2
  exit 1
fi

if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  kind create cluster --name "${CLUSTER_NAME}"
else
  echo "kind cluster '${CLUSTER_NAME}' already exists"
fi

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null
