# CRD/Webhook Fast Loop Guide (Kubebuilder + Tilt)

This guide describes a dev-only fast feedback loop for Kubernetes CRD operators and webhooks built with Kubebuilder.

Goal: run one command (`make dev`), then iterate on Go code without rebuilding container images on every change.

## Who this is for
- DevOps engineers building or editing CRD controllers/webhooks
- Kubebuilder projects using Kustomize
- Local dev with kind

## What you get
- `make dev` starts the whole loop
- CRDs/RBAC/Webhooks applied via Kustomize
- Manager binary compiled locally and live-updated into the running pod
- The manager process is killed/restarted so new code takes effect quickly

## Quick start (structure)
1) Add the files from this guide to your repo
2) Ensure your Kubebuilder project uses `config/` and Kustomize
3) Run `make dev`
4) Edit Go code and watch behavior update fast

## Helper scripts
- `make kind` creates a kind cluster
- `make deploy` applies the Kustomize dev overlay
- `make verify` shows basic CRD/webhook/pod status
- `make prereqs` checks and installs missing tools

## How to use this guide
- Start with `WORKFLOW.md` for the steps
- Use `PROMPTS.md` to capture requirements and safety rules
- Use `CHECKLIST.md` before shipping
- Use `MCP_SETUP.md` if you want an agent-driven feedback loop

## Scope
- Dev-only, kind-only by default
- Combined manager (controller + webhook) process
- Go-only for the first version

## Non-goals
- Production deployment
- Multi-language support (can be added later)
- Replacing Helm/Kustomize packaging standards
