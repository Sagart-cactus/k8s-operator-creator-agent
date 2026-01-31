# Dev Fast Loop Workflow (Kubebuilder + Tilt)

This workflow assumes a Kubebuilder project with Kustomize under `config/`.

## Overview
- One command: `make dev`
- Kustomize applies CRDs, RBAC, webhook config, and manager Deployment
- Local `go build` produces the manager binary
- Tilt live-update syncs the binary into the running manager pod
- Tilt kills the process to restart with new code

## Steps

### 1) Add a dev overlay in Kustomize
Create a `config/dev/` overlay that:
- disables leader election (single replica)
- sets image to a placeholder (Tilt will live-update)
- reduces resource limits if needed
- uses local webhook certs (if required)

### 2) Configure Tilt
Tilt should:
- run `kustomize build config/dev` and apply it
- build the manager binary locally
- sync the binary into the manager container
- kill the running manager process after sync

### 3) Use `make dev`
The Make target should be a thin wrapper that runs `tilt up`.

### 4) Iterate
- Edit Go files
- Tilt recompiles locally
- Binary syncs into the running pod
- Process restarts
- You see logs/events fast

## Expected outcomes
- No Docker image rebuild for normal code changes
- Fast feedback loop (compile + sync + restart)
- CRD/webhook changes are applied through Kustomize

## When you still need a full rebuild
- Dockerfile changes
- Base image changes
- Dependency changes that affect the image environment

## Minimal files to add
- `Tiltfile`
- `Makefile` target for `make dev`
- `config/dev/` Kustomize overlay

See `PROMPTS.md` for how to capture requirements and safety constraints.
