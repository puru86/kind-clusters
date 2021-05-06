# kind-clusters
Kubernetes local clusters based on Kubernetes-in-Docker (kind). Read more here: https://kind.sigs.k8s.io/

# Branches
In this repository I am trying to create clusters for different versions of Kubernetes. 

Different versions of kubernetes are supported using different branches.

For ex. `version/1.13.12` builds clusters for Kubernetes 1.13.12

`master` will remain empty to avoid confusion!

# Clusters
I try to provide three types of clusters:

## `{version}-plain`
For Example: `1.13.12-plain`

The cluster will include:
- The `kind cluster` for the appropriate Kubernetes Version.
- A `serviceaccount` named `dev-admin` with full access to the cluster.
- The `kubernetes-dashboard` service deployed and mapped to `https://127.0.0.1:18001`
- Configured with additional port mappings:
    - 18002 (host) : 30002 (cluster)
    - 18003 (host) : 30003 (cluster)
    - 18004 (host) : 30004 (cluster)
    - 18005 (host) : 30005 (cluster)
    - 18006 (host) : 30006 (cluster)
    - 18007 (host) : 30007 (cluster)
    - 18008 (host) : 30008 (cluster)
    - 18009 (host) : 30009 (cluster)
    - 18010 (host) : 30010 (cluster)
    - 18011 (host) : 30011 (cluster)

## `{version}-gateway`
For Example: `1.13.12-gateway`

The cluster will include:
- The `kind cluster` for the appropriate Kubernetes Version.
- A `serviceaccount` named `dev-admin` with full access to the cluster.
- A `nginx-service` that behaves as a gateway (really a reverse proxy) mapped to `http://127.0.0.1:18001`
- The `kubernetes-dashboard` service deployed and reverse proxied at `http://127.0.0.1:18001/kube-system/kubernetes-dashboard/`

## `{version}-registry`
For Example: `1.13.12-registry`

The host (in my case a Mac) will be running a private docker `registry:2`, exposed at `localhost:5000`.

The cluster will include:
- The `kind cluster` for the appropriate Kubernetes Version.
- A `serviceaccount` named `dev-admin` with full access to the cluster.
- A `nginx-service` that behaves as a gateway (reverse-proxy) mapped to `http://127.0.0.1:18001`
- The