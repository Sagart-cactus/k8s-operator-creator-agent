#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${1:-system}

kubectl get crds
kubectl -n "${NAMESPACE}" get pods
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
kubectl -n "${NAMESPACE}" get events --sort-by=.lastTimestamp | tail -n 20
