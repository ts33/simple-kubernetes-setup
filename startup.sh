#!/bin/sh

if [[ -z "${POSTGRES_SECRET}" ]]; then
  echo "POSTGRES_SECRET is undefined, set it first using the command `EXPORT POSTGRES_SECRET=<xxx>`"
  exit 1
fi

echo "-- Starting Minikube --"
minikube start
eval $(minikube -p minikube docker-env)

echo "-- Building Docker Images --"
echo "- Building docker image node-app"
docker build --no-cache -t node-app -f dockerfile.app .
echo "- Building docker image db-seed"
docker build --no-cache -t db-seed -f dockerfile.db-seed .

echo "-- Creating Kubernetes Resources --"
kubectl create secret generic postgres-pass --from-literal=password="${POSTGRES_SECRET}"
kubectl apply -k ./kube/overlays/dev

echo "-- Listing Kubernetes Resources --"
echo "- secrets"
kubectl get secret
echo "- deployments"
kubectl get deployments
echo "- pods"
kubectl get pods 
echo "- services"
kubectl get services

grep -q "$SUB" <<< "$STR"

while [[ "$(kubectl get pods -l=app='simple-api' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != *"true"* ]]; do
   sleep 5
   echo "Waiting for Simple API to be ready."
done

echo "-- Forwarding Simple API Port --"
echo "- Access the api at http://localhost:7000"
kubectl port-forward service/simple-api 7000:8000
