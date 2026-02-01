# Building CRD Operators Faster with Tilt + AI Agents: A Practical Feedback Loop

Kubernetes CRD operators and webhooks are powerful, but the development loop is notoriously slow. You write Go code, rebuild the image, load it into a cluster, deploy manifests, test, repeat. That friction is the biggest reason DevOps engineers avoid writing operators or webhooks themselves—even when they know it would solve real problems.

## Why Tilt Matters for CRDs and Webhooks

Tilt is built for tight local feedback loops. Instead of “build image → push → deploy” on every change, Tilt can live‑update a running container: sync a freshly compiled binary into the pod and restart the process in seconds. For operators and webhooks, this is game‑changing because most changes are in Go code, not Dockerfile or base image. Learn more about Tilt and live updates here: https://tilt.dev and https://docs.tilt.dev/live_update_reference.html

The pattern looks like this:

1. Local `go build` produces the manager binary
2. Tilt syncs that binary into the running manager pod
3. Tilt restarts the process
4. You immediately see new behavior in logs or events

This is the fastest loop you can get without shifting the operator entirely to a local run (which is harder for admission webhooks and TLS).

## Why AI Agents Usually Miss This

Most AI agents that generate Kubernetes code stop at scaffolding. They can write a CRD schema, generate controller logic, and produce YAML—but they don’t integrate a developer feedback loop. The result is “code that exists” rather than “code you can iterate on quickly.”

That gap matters because **operators require iteration**. The first pass is almost always wrong: schema needs tweaks, webhook invariants need correction, RBAC is too broad, or reconcile logic misses edge cases. Without a fast loop, every fix is expensive—and agents aren’t incentivized to optimize the human‑in‑the‑loop experience.

## Why Fast, Reliable Feedback Is Essential for Agents

An agent’s output quality depends on its ability to see consequences. If the agent can immediately deploy, observe, and validate, it can self‑correct.

For CRDs and webhooks, the feedback must include:

- CRD registration success
- Webhook configuration installed and serving
- Manager pod running with the new binary
- Admission failures or reconcile errors surfaced quickly

A **fast, reliable feedback loop** makes the agent better and makes the user trust the agent.

## The Repo: K8s Operator Creator Agent

This project is an agent‑first workspace that bakes the feedback loop into the workflow. It combines:

- Kubebuilder + Kustomize for standard operator scaffolding
- Tilt for live‑update and rapid iteration
- kind for dev‑only cluster safety
- Optional MCP validation or kubectl verification

The agent:

1) asks for CRD purpose, fields, validations, webhook type
2) generates code and manifests
3) deploys to kind
4) validates the cluster and iterates

It’s designed to reduce the gap between “I have an idea for a CRD” and “I have a working operator and webhook in a local cluster.”

Repository (copy/paste):

```
https://github.com/Sagart-cactus/k8s-operator-creator-agent
```

## How to Try It (Sample Prompt)

Here’s a concrete sample prompt you can use with Codex or Claude Code inside the repo:

```
You are the CRD/Webhook Builder agent for this repo. Follow AGENTS.md strictly.

Goal: build a “TTLJob” CRD that runs a Job and auto-deletes it after a TTL.

Requirements:
- CRD: TTLJob with spec fields:
  - image (string, required)
  - command ([]string, optional)
  - ttlSeconds (int, required)
  - backoffLimit (int, optional, default 3)
  - labels (map[string]string, optional)
- Status fields:
  - phase (string: Pending/Running/Succeeded/Failed)
  - startTime (timestamp)
  - completionTime (timestamp)
  - jobName (string)
- Validating webhook:
  - ttlSeconds must be >= 60
  - image must be non-empty
  - backoffLimit must be 0..10
- Mutating webhook:
  - default backoffLimit to 3
  - default ttlSeconds to 3600 if not set
- RBAC: namespace-scoped
- Safety: only mutate CRs labeled “dev-mode=true”
- Fast dev loop: use Tilt + local compile + binary sync + restart
- Use kubebuilder + kustomize conventions

Steps:
1) Ask any missing questions (only if needed)
2) Generate CRD schema, controller logic, webhook scaffolding
3) Add Tiltfile, dev overlay, and Make targets
4) Create kind cluster and deploy
5) Verify with MCP if available, otherwise kubectl
6) Summarize how to run `make dev` and test with a sample CR
```

## Closing Thoughts

Tilt is not just a developer convenience—it’s a critical piece of the reliability story for AI agents. When an agent can test, observe, and iterate rapidly, its outputs improve dramatically. That’s exactly what this repo tries to enable: a fast, safe, and repeatable loop for CRD operators and webhooks.

If you build with CRDs or work in DevOps, I’d love feedback.

Tags:
- #kubernetes
- #devops
- #operator
- #ai
