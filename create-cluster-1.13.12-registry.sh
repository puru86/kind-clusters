#! /bin/sh

clear && clear 

CLUSTER_NAME="1.13.12-registry"

echo ====================================================
echo Creating Registry: kind-registry
echo ====================================================

running="$(docker inspect -f '{{.State.Running}}' "kind-registry" 2>/dev/null || true)"

if [ "${running}" != 'true' ]; 
    then
        docker run -d --restart=always -p "127.0.0.1:5000:5000" --name "kind-registry" registry:2
    else 
        echo kind-registry is already running
fi

echo ====================================================
echo Creating Cluster ${CLUSTER_NAME}
echo ====================================================

kind create cluster --config=kind-cluster-configs/cluster-${CLUSTER_NAME}.yaml

echo ====================================================
echo Listing Clusters
echo ====================================================

kind get clusters

echo ====================================================
echo Connecting kind-registry to kind network
echo ====================================================

docker network connect "kind" "kind-registry" || true

echo ====================================================
echo Documenting Local registry
echo ====================================================
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:5000"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

echo ====================================================
echo Making image available locally
echo ----------------------------------------------------
echo Pull gcr.io/google-samples/hello-app:1.0
echo ----------------------------------------------------

docker pull gcr.io/google-samples/hello-app:1.0

echo ----------------------------------------------------
echo Tag localhost:5000/hello-app:1.0
echo ----------------------------------------------------

docker tag gcr.io/google-samples/hello-app:1.0 localhost:5000/hello-app:1.0

echo ----------------------------------------------------
echo Push localhost:5000/hello-app:1.0
echo ----------------------------------------------------

docker push localhost:5000/hello-app:1.0

echo ====================================================

echo ====================================================
echo Applying Kubernetes Manifests
echo Using overlays/hello-app
echo ====================================================

kubectl apply -k kustomize/overlays/hello-app/

echo ====================================================
echo Waiting on deployment roll-out
echo ====================================================

kubectl rollout status deployment/kubernetes-dashboard -n kube-system
kubectl rollout status deployment/nginx-deployment -n nginx
kubectl rollout status deployment/hello-app-deployment

echo ====================================================
echo All Kubernetes Assets
echo ====================================================

kubectl get all --all-namespaces

echo ====================================================
echo cluster-info
echo ====================================================

kubectl cluster-info

echo ====================================================
echo What next?
echo ----------------------------------------------------
echo API Server is available at https://127.0.0.1:16443/
echo nginx-service is available at http://127.0.0.1:18001/
echo Kubernetes Dashboard will be available at http://127.0.0.1:18001/kube-system/kubernetes-dashboard/
echo hello-app service will be available at http://127.0.0.1:18001/default/hello-app/
echo ====================================================

echo ====================================================
echo dev-admin token
echo ----------------------------------------------------
DEV_ADMIN_TOKEN_NAME=$(kubectl get secrets | grep "dev-admin" | awk -F" " '{print $1;}')
DEV_ADMIN_TOKEN=$(kubectl get secret $DEV_ADMIN_TOKEN_NAME --template={{.data.token}} | base64 -d)
echo $DEV_ADMIN_TOKEN
echo ----------------------------------------------------
echo This token has been saved to running-cluster-info/${CLUSTER_NAME}.txt
mkdir -p running-cluster-info

echo """
DEV_ADMIN_TOKEN_NAME: 
$DEV_ADMIN_TOKEN_NAME

DEV_ADMIN_TOKEN:
$DEV_ADMIN_TOKEN

API Server is available at https://127.0.0.1:16443/
nginx-service is available at http://127.0.0.1:18001/
Kubernetes Dashboard will be available at http://127.0.0.1:18001/kube-system/kubernetes-dashboard/
hello-app service will be available at http://127.0.0.1:18001/default/hello-app/

""" > running-cluster-info/${CLUSTER_NAME}.txt
echo ====================================================


