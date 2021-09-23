#!/bin/bash

set -euo pipefail

ID1="1"
ID2="2"
CLUSTER1="cilium$ID1"
CLUSTER2="cilium$ID2"

function delete_cluster() {
  kind delete cluster --name "$1"
}

echo "Deleting KIND clusters ..."
delete_cluster "$CLUSTER1"
delete_cluster "$CLUSTER2"
