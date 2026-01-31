# CRD/Webhook Fast Loop Checklist

## Safety (dev-only)
- [ ] Target cluster is kind or explicitly allowed
- [ ] Leader election disabled for dev
- [ ] Single replica manager
- [ ] Webhook timeouts are short for dev
- [ ] Webhook only mutates resources it owns or is explicitly allowed to modify

## CRD
- [ ] Structural schema is valid
- [ ] Required fields are set
- [ ] Default values are defined where possible
- [ ] Status subresource enabled (if used)

## Webhooks
- [ ] Validating webhook covers invariants
- [ ] Mutating webhook only defaults safe fields
- [ ] Failure policy is safe for dev
- [ ] Certificates exist and are mounted

## RBAC
- [ ] Minimal verbs and resources
- [ ] No cluster-wide permissions unless required
- [ ] Separate roles for manager and webhook if needed

## Fast loop
- [ ] Local compile succeeds
- [ ] Binary sync into running pod works
- [ ] Process restart is reliable
- [ ] Logs show new version after edit

## Troubleshooting
- [ ] Check Tilt logs for sync errors
- [ ] Check pod logs for crash loops
- [ ] Verify webhook service endpoints
