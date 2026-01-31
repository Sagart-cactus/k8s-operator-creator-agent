# K8s Operator Creator Agent

This repo turns Kubernetes operator development into a **guided, high‑speed workflow**. Run a Codex or Claude Code agent in this repo, answer a handful of questions, and watch it generate a working CRD + webhook and deploy it to a local kind cluster — **fast**.

## Who this is for
- DevOps engineers building or editing CRD controllers/webhooks
- Kubebuilder projects using Kustomize
- Local dev with kind

## The intended flow
1) Clone this repo  
2) Run the agent (Codex or Claude Code)  
3) Answer a short Q&A (purpose, fields, validations, webhook type)  
4) The agent **writes the code** and **generates manifests**  
5) The agent **creates a kind cluster** and installs the CRD/webhook  
6) The agent **iterates with fast feedback** (Tilt live‑update + cluster checks)

## Quick start (structure)
1) Make sure you have Go, kind, kubectl, kustomize, and Tilt  
2) Run `make prereqs` for auto‑install  
3) Run your agent (Codex or Claude Code) in this repo  
4) Follow the prompts — the agent builds + deploys  
5) Keep the loop hot with `make dev`

## Helper scripts
- `make kind` creates a kind cluster
- `make deploy` applies the Kustomize dev overlay
- `make verify` shows basic CRD/webhook/pod status
- `make prereqs` checks and installs missing tools

## How to use this guide
- `AGENTS.md` is the **agent contract** (what it must do)
- `WORKFLOW.md` is the **fast loop recipe**
- `PROMPTS.md` + `CHECKLIST.md` are the **guardrails**
- `MCP_SETUP.md` wires in **cluster‑aware feedback**

## Scope
- Dev-only, kind-only by default
- Combined manager (controller + webhook) process
- Go-only for the first version

## Non-goals
- Production deployment
- Multi-language support (can be added later)
- Replacing Helm/Kustomize packaging standards

## Why this is different
- It’s **agent‑first**: the workflow lives in `AGENTS.md`
- It’s **fast by default**: no image rebuild loop for typical code changes
- It’s **safe by design**: kind‑only and dev‑only
