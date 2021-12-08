#!/bin/sh

echo "-- Deleting Kubernetes Resources --"
kubectl delete -k ./kube/overlays/dev

minikube stop
