#!/bin/bash

set -euo pipefail

echo "Testing load balancing between clusters..."
POD=$(kubectl get pod -l name=x-wing -o jsonpath='{.items[0].metadata.name}')
for i in $(seq 1 30); do
  kubectl exec -it "$POD" -- curl rebel-base
done
