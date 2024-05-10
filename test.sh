#!/bin/bash

docker build -t e2e/initcontainer-python:e2e python/
minikube image load e2e/initcontainer-python:e2e

docker build -t e2e/python-test-app:e2e .github/containers/python/
minikube image load e2e/python-test-app:e2e

kubectl delete -f .github/containers/python/customresource.yaml -n python-test
kubectl apply -f .github/containers/python/customresource.yaml -n python-test

kubectl delete -f .github/containers/python/python_test_app_deployment.yaml -n python-test
kubectl apply -f .github/containers/python/python_test_app_deployment.yaml -n python-test

kubectl get pods --namespace=python-test

# kubectl logs -n python-test $(kubectl get pods --namespace=python-test | grep python-test | cut -d" " -f1)

kubectl wait --for=condition=Ready --namespace python-test --all pods
minikube service python-test-app-service --url --namespace python-test