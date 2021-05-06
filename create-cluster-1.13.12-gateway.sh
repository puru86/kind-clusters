#! /bin/sh

clear && clear 

CLUSTER_NAME="1.13.12-gateway"

echo ====================================================
echo Creating Cluster ${CLUSTER_NAME}
echo ====================================================

kind create cluster --config=kind-cluster-configs/cluster-${CLUSTER_NAME}.yaml

echo ====================================================
echo Listing Clusters
echo ====================================================

kind get clusters

echo ====================================================
echo Applying Kubernetes Manifests
echo Using overlays/gateway
echo ====================================================

kubectl apply -k kustomize/overlays/gateway/

echo ====================================================
echo Waiting on deployment roll-out
echo ====================================================

kubectl rollout status deployment/kubernetes-dashboard -n kube-system
kubectl rollout status deployment/nginx-deployment -n nginx

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
Kubernetes Dashboard will be available at http://127.0.0.1:18001/

""" > running-cluster-info/${CLUSTER_NAME}.txt
echo ====================================================


