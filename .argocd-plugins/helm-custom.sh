#!/bin/sh
helm template "$ARGOCD_APP_NAME" . \
  --namespace "$ARGOCD_APP_NAMESPACE" \
  --values values.yaml
