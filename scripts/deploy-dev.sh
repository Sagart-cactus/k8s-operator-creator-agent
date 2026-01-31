#!/usr/bin/env bash
set -euo pipefail

OVERLAY_PATH=${1:-config/dev}

if ! command -v kustomize >/dev/null 2>&1; then
  echo "kustomize is not installed" >&2
  exit 1
fi

kustomize build "${OVERLAY_PATH}" | kubectl apply -f -
