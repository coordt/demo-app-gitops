#!/usr/bin/env bash

# Requires Helm and Kustomize to be installed

ARGOCD_APP_SOURCE_REPO_URL=https://github.com/coordt/demo-app-gitops
ARGOCD_APP_REVISION=$(git rev-parse HEAD)
ENV_NAME=${1:-dev}

# Determine the location of the environment (prod or non-prod)
if [[ -d non-prod-envs/${ENV_NAME} ]]; then
  ENV_PATH=non-prod-envs/${ENV_NAME}
elif [[ -d prod-envs/${ENV_NAME} ]]; then
  ENV_PATH=prod-envs/${ENV_NAME}
else
  echo "Could not find an environment named '${ENV_NAME}'."
  exit 1
fi

cd ${ENV_PATH} && \
  helm template ../../chart \
  --name-template ${ENV_NAME} \
  --namespace ${ENV_NAME} \
  -f ../../chart/components.yaml \
  -f overrides.yaml \
  --set environment=${ENV_NAME} \
  --set clusterName=centralus-dsmatching-aks-prod \
  --set appRevision=${ARGOCD_APP_REVISION} \
  --set appVersion=${ARGOCD_APP_REVISION:0:7} \
  --set sourceURL=${ARGOCD_APP_SOURCE_REPO_URL} \
  --set releaseURL=${ARGOCD_APP_SOURCE_REPO_URL}/commit/${ARGOCD_APP_REVISION} \
  --include-crds > ../../chart/all.yml && \
  kustomize build > ../../chart-${ENV_NAME}.yaml && \
  cd - || exit
