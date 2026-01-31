# MCP Setup (Optional Agent Feedback Loop)

This section is optional. It describes how an AI agent can validate the cluster state
and give fast feedback during the dev loop.

## Recommended MCP servers
Pick one Kubernetes MCP server:
- containers/kubernetes-mcp-server
- StacklokLabs/mkp

Use it to:
- read CRDs and validate schema presence
- read events and logs for controller/webhook failures
- verify webhook configurations and service endpoints

## Suggested agent checks
- CRD exists and version is correct
- Webhook configurations are installed
- Manager pod is running and ready
- Recent events show no admission failures
- Logs show reconcile loop is active

## Guardrails
- Block destructive operations by default
- Only allow write operations in a dev cluster context
- Prefer namespace-scoped changes

## Where the agent fits
- The agent runs alongside Tilt (locally)
- After each code sync, it runs MCP checks
- It reports issues in plain language
