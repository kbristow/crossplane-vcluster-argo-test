#!/bin/bash
# Run from the directory this script lives in
k3d cluster delete cf-kubecon23-demo
k3d cluster create cf-kubecon23-demo --volume $(pwd)/certs/ZscalerRootCA.crt:/etc/ssl/certs/ZscalerRootCA.crt
k3d kubeconfig get cf-kubecon23-demo > /tmp/k3d-cf-kubecon23-demo.config
export KUBECONFIG=/tmp/k3d-cf-kubecon23-demo.config
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
# https://github.com/cf-kubecon23-demo/cf-kubecon23-demo/issues/2121
helm install --repo https://argoproj.github.io/argo-helm --create-namespace --namespace argocd argocd argo-cd --version 5.37.1  --values argocd-values.yaml --set "configs.cm.application\.resourceTrackingMethod=annotation" --wait
kubectl apply -f argo-helm-repo.yaml
kubectl -n argocd apply -f app-of-apps.yaml