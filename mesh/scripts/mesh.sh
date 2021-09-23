#!/bin/bash

set -euo pipefail

CILIUM_VERSION="1.10.4"
ID1="1"
ID2="2"
CLUSTER1="cilium$ID1"
CLUSTER2="cilium$ID2"
CONTEXT1="kind-$CLUSTER1"
CONTEXT2="kind-$CLUSTER2"

function create_cluster() {
  kind create cluster --name "$1" --config "kind/$1.yaml"
}

function deploy_app() {
  kubectl config use-context "$1"
  kubectl apply -f "manifests/$2.yaml"
}

echo "Creating KIND clusters ..."
create_cluster "$CLUSTER1"
create_cluster "$CLUSTER2"

echo "Installing Cilium ..."
cilium install --context "$CONTEXT1" --cluster-name="$CLUSTER1" --cluster-id="$ID1" --ipam kubernetes --version "$CILIUM_VERSION"
cilium status --context "$CONTEXT1"
cilium install --context "$CONTEXT2" --cluster-name="$CLUSTER2" --cluster-id="$ID2" --ipam kubernetes --version "$CILIUM_VERSION" --inherit-ca="$CONTEXT1"
cilium status --context "$CONTEXT2"

echo "Meshing the clusters ..."
cilium clustermesh enable --context "$CONTEXT1" --service-type NodePort
cilium clustermesh enable --context "$CONTEXT2" --service-type NodePort
cilium clustermesh status --context "$CONTEXT1" --wait
cilium clustermesh status --context "$CONTEXT2" --wait
cilium clustermesh connect --context "$CONTEXT1" --destination-context="$CONTEXT2"
cilium clustermesh status --context "$CONTEXT1" --wait
cilium clustermesh status --context "$CONTEXT2" --wait

echo "Deploying the application ..."
deploy_app "$CONTEXT1" "$CLUSTER1"
deploy_app "$CONTEXT2" "$CLUSTER2"

echo "Done!"
