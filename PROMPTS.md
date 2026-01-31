# Prompts for Reliable CRD/Webhook Development

These prompts are meant for an AI assistant or Codex-style workflow.

## 1) Problem framing
"Summarize the user problem in one sentence. List the CRD's top 3 responsibilities. Identify safety risks."

## 2) CRD schema design
"Propose a CRD spec and status. Include required fields, defaults, and validation rules."

## 3) Webhook design
"Define validating and/or mutating webhook rules. List what must be blocked vs auto-defaulted."

## 4) Reconcile loop outline
"Provide a step-by-step reconcile flow. Include idempotency and error handling."

## 5) RBAC minimization
"List the minimal RBAC permissions required for this controller and webhook."

## 6) Dev fast loop setup
"Generate a Tiltfile workflow for Go + kubebuilder that compiles locally, syncs the binary into the pod, and restarts the manager."

## 7) Safety gate (dev-only)
"Ensure the workflow only targets kind or a dev cluster context. Provide a guard check."

## 8) Test outline
"Provide a minimal set of tests for this CRD and webhook: unit, envtest, and an example manifest."
