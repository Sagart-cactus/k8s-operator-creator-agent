# CRD/Webhook Builder Agent (Codex + Claude Code)

This repo is a **Codex/Claude Code agent workspace** for building Kubernetes CRDs and webhooks with a fast local feedback loop.

## Operating mode
- **Default**: use MCP (Kubernetes MCP server) for cluster validation.
- **Opt-out**: if MCP is not available, fall back to `kubectl` commands.
- **Dev-only**: target kind clusters only.

## Agent responsibilities
1) Ask questions to clarify CRD purpose, fields, validation rules, webhook type, and safety constraints.
2) Generate CRD schema + examples.
3) Scaffold controller + webhook code (Go + Kubebuilder patterns).
4) Create dev loop config: Tiltfile + Kustomize dev overlay + Makefile target.
5) Create a kind cluster and install CRDs/webhooks.
6) Validate behavior using MCP or `kubectl` and logs.
7) Iterate until requirements are satisfied.

## Required Q&A (ask before writing code)
Ask these and wait for answers:
- CRD purpose (1 sentence)
- Spec fields (name + type + required?)
- Status fields (what should be reported?)
- Webhook type (validating, mutating, or both)
- Defaulting rules (if any)
- Validation rules (invariants)
- RBAC scope (namespace or cluster)
- Resource ownership (what objects are created/managed)
- Failure policy (for webhooks)
- Safety gates (annotations/labels to enable mutations)

## Output expectations
- Code and manifests are written to the repo.
- Provide a short runbook: `make dev`, example CRs, and how to see logs.

## Files the agent should manage
- `README.md` (keep overview in sync)
- `WORKFLOW.md`, `PROMPTS.md`, `CHECKLIST.md`
- `Tiltfile`
- `Makefile`
- `config/dev/` Kustomize overlay
- `config/crd/bases/` CRD YAML
- `config/webhook/` webhook configuration
- `config/rbac/` RBAC rules

## Tooling assumptions
- Go + Kubebuilder conventions
- Kustomize under `config/`
- kind for local cluster
- Tilt for fast dev loop

## MCP usage (default)
If MCP is available, prefer it to validate:
- CRDs installed and versions match
- Webhook configs present
- Manager/webhook pods healthy
- Logs show reconcile activity

If MCP is not available, use `kubectl` equivalents.

## Safety guardrails
- Allow only `kind-*` contexts
- Refuse operations on non-kind contexts unless user explicitly overrides
- Avoid destructive operations by default

