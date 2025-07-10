# FluxCD GitOps Deployment

## Overview
This repository implements GitOps with FluxCD for Kubernetes cluster management. All cluster states are declared via YAML files versioned in Git.

## Architecture
- FluxCD (source-controller, kustomize-controller, helm-controller)
- Kubernetes (v1.27+)
- OCI Helm charts & Kustomize overlays
- External secrets via ExternalSecrets operator
- Infra on AWS EKS or local (kind/minikube)


## How to Bootstrap
```bash
flux bootstrap github \
  --owner=AntonioJordan \
  --repository=cicdcompletelab-argocd \
  --branch=main \
  --path=fluxcd-prod \
  --personal 


flux create source helm prometheus-repo \
  --url=https://prometheus-community.github.io/helm-charts \
  --namespace=flux-system \
  --interval=1h




```

## Apply changes
1. Commit YAML to appropriate path.
2. Flux will reconcile automatically.
3. Check status:
```bash
flux get kustomizations
flux get sources git
```

## Secrets Management
Use `ExternalSecrets` + AWS Secrets Manager (or Vault).
YAMLs under `infra/external-secrets`.

## Helm Releases
Defined under `apps/*/helmrelease.yaml` using `HelmRelease` CRD.
Charts sourced from `HelmRepository` or `OCIRepository`.

## Sync structure
- `GitRepository`: points to this repo
- `Kustomization`: defines reconciliation
- `HelmRepository`/`HelmRelease`: for Helm-based apps
- `OCIRepository`: for OCI charts

## Observability
- Prometheus and Grafana installed via Helm
- Dashboards provisioned via configMaps

## Deployment Flow
1. Push to main branch
2. Flux detects change
3. Reconciles Git state to cluster state

## Troubleshooting
```bash
flux logs --level=error
flux get kustomizations
flux get sources
kubectl describe kustomization <name>
```

## CI/CD Integration
Use GitHub Actions to validate YAML and trigger updates.

## Requirements
- flux CLI
- kubectl
- access to target Kubernetes cluster
- Helm 3.x
