# Templates (Tilt + Make + Kustomize)

These are starting points. Adapt paths to your repo.

## Makefile (dev target)
```make
.PHONY: dev

dev:
\ttilt up
```

## Kustomize dev overlay
Create `config/dev/kustomization.yaml`:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../default

patchesStrategicMerge:
  - manager_dev_patch.yaml
```

Example `config/dev/manager_dev_patch.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: controller-manager
  namespace: system
spec:
  replicas: 1
  template:
    spec:
      containers:
        - name: manager
          image: local/dev-manager:dev
          args:
            - --leader-elect=false
```

## Tiltfile (local compile + live update)
This is a Go-focused pattern:

```python
# Allow only kind for safety
allow_k8s_contexts('kind-kind')

# Build and deploy via kustomize
k8s_yaml(kustomize('config/dev'))

# Local compile step
local_resource(
    'build-manager',
    'go build -o bin/manager ./cmd',
    deps=['cmd', 'api', 'internal', 'pkg'],
)

# Image + live update to sync binary
# Replace image ref to match your Deployment
docker_build(
    'local/dev-manager',
    '.',
    only=['bin/manager'],
    live_update=[
        sync('bin/manager', '/manager'),
        run('pkill -f /manager || true'),
    ],
)

# Associate the image with the k8s resource
k8s_resource('controller-manager', image='local/dev-manager', deps=['build-manager'])
```

Notes:
- Adjust binary path and container command as needed.
- If your container runs `/manager` as PID 1, `pkill` may restart the process.
- If it does not restart, add a lightweight supervisor or modify the container entrypoint.
