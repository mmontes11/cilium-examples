### mesh

Cilium cluster mesh using 2 KIND clusters. Docs available [here](https://docs.cilium.io/en/stable/gettingstarted/clustermesh/clustermesh/).


#### Requirements
- [KIND](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Cilium](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/)


#### Install and mesh clusters
```bash
./scripts/mesh.sh
```

#### Test load balancing between clusters
```bash
./scripts/test.sh
```

#### Delete clusters
```bash
./scripts/cleanup.sh
```