# kind-clusters
Kubernetes local clusters based on Kubernetes-in-Docker (kind). Read more here: https://kind.sigs.k8s.io/

# NOT FOR PRODUCTION
THIS IS NOT FOR PRODUCTION.

These are development only cluster configurations. I hardly ever will make the effort to setup an SSL if I can avoid the complexity.

I am creating these clusters to experiment with webhooks, third party tools, third party addons and to understand Kubernetes internals like lifecycles.

# Branches
In this repository I am trying to create clusters for different versions of Kubernetes. 

Different versions of kubernetes are supported using different branches.

For example: `version/1.13.12` builds clusters for Kubernetes 1.13.12

`master` will remain empty to avoid confusion!

# Clusters
I try to provide three types of clusters:

## `{version}-plain`
For example: `1.13.12-plain`

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
For example: `1.13.12-gateway`

The cluster will include:
- The `kind cluster` for the appropriate Kubernetes Version.
- A `serviceaccount` named `dev-admin` with full access to the cluster.
- A `nginx-service` that behaves as a gateway (really a reverse proxy) mapped to `http://127.0.0.1:18001`
- The `kubernetes-dashboard` service deployed and reverse proxied at `http://127.0.0.1:18001/kube-system/kubernetes-dashboard/`
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

## `{version}-registry`
For example: `1.13.12-registry`

The host (in my case a Mac) docker will be configured with:
- Container called `kind-registry`, running image `registry:2`, exposed at `localhost:5000`.
- Network `kind` will be updated to allow access to `kind-registry` creating a docker network bridge for the `kind cluster` to use.

The cluster will include:
- The `kind cluster` for the appropriate Kubernetes Version.
- A `serviceaccount` named `dev-admin` with full access to the cluster.
- Configuration to allow `kind cluster` to connect to the local registry.
- A `nginx-service` that behaves as a gateway (reverse-proxy) mapped to `http://127.0.0.1:18001`
- The `kubernetes-dashboard` service deployed and reverse proxied at `http://127.0.0.1:18001/kube-system/kubernetes-dashboard/`
- The `gcr.io/google-samples/hello-app:1.0` image will be deployed to the cluster as a local image `localhost:5000/hello-app:1.0`
- This image will be available as service `hello-app` mapped to `http://127.0.0.1:18001/default/hello-app/`
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