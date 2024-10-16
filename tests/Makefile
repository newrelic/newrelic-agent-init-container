# Constants
MAKEFILE_DIR:=$(dir $(realpath $(firstword ${MAKEFILE_LIST})))
REPO_ROOT:=$(realpath ${MAKEFILE_DIR}../)
TEMPLATE_FILE:=$(realpath ${MAKEFILE_DIR})/${INITCONTAINER_LANGUAGE}/template_file.yaml

# Initcontainer language under test
INITCONTAINER_LANGUAGE:=${INITCONTAINER_LANGUAGE}

# Path to the local copy of the repo newrelic/k8s-agents-operator.
# Only required if building and testing the operator from source.
LOCAL_OPERATOR_REPO_PATH:=${REPO_ROOT}/../k8s-agents-operator

.PHONY: default
default: all

# Install all dependencies and run all tests
.PHONY: all
all: all-k8s all-azure 

# Install all Kubernetes dependencies and run tests
.PHONY: all-k8s
all-k8s: minikube cert-manager k8s-operator k8s-test

# Install all Azure dependencies and run tests
.PHONY: all-azure
all-azure: azure-env deploy-azure-images azure-container-app license_key_env_vars-azure template-file-upload 

# Start minikube
.PHONY: minikube
minikube:
	minikube start --driver=docker

# Install jetstack/cert-manager dependency
.PHONY: cert-manager
cert-manager:
	helm repo add jetstack https://charts.jetstack.io --force-update
	helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.14.5 --set installCRDs=true
	sleep 1
	kubectl wait --for=condition=Ready -n cert-manager --all pods --timeout=60s

# Install official k8s-agents-operator repo
.PHONY: k8s-operator
k8s-operator: cert-manager license_key_secret-k8s
	helm uninstall k8s-agents-operator --ignore-not-found
	helm repo add k8s-agents-operator https://newrelic.github.io/k8s-agents-operator
	helm upgrade --install k8s-agents-operator k8s-agents-operator/k8s-agents-operator \
		--create-namespace \
		--namespace=k8s-agents-operator \
		--set=licenseKey=${NEW_RELIC_LICENSE_KEY} \
		--set=controllerManager.manager.image.tag=edge
	sleep 1
	kubectl wait --for=condition=Ready -n k8s-agents-operator --all pods

# Build and install local copy of k8s-agents-operator
.PHONY: k8s-operator-local
k8s-operator-local: license_key_secret-k8s
	eval $$(minikube docker-env --shell=bash) && \
		docker build ${LOCAL_OPERATOR_REPO_PATH}/ -t e2e/k8s-agents-operator:e2e
	helm uninstall k8s-agents-operator --ignore-not-found
	sleep 1
	helm upgrade --install k8s-agents-operator ${LOCAL_OPERATOR_REPO_PATH}/charts/k8s-agents-operator/ \
		--create-namespace \
		--namespace=k8s-agents-operator \
		--set=licenseKey=${NEW_RELIC_LICENSE_KEY} \
		--set=controllerManager.manager.image.pullPolicy=Never \
		--set=controllerManager.manager.image.repository=e2e/k8s-agents-operator \
		--set=controllerManager.manager.image.tag=e2e
	sleep 1
	kubectl wait --for=condition=Ready -n k8s-agents-operator --all pods

# Set license key in default namespace
.PHONY: license_key_secret-k8s
license_key_secret-k8s:
	kubectl delete secret newrelic-key-secret --ignore-not-found
	kubectl create secret generic newrelic-key-secret \
		--from-literal="new_relic_license_key=${NEW_RELIC_LICENSE_KEY}" \
		-n default

# Build local Kubernetes initcontainer image
.PHONY: build-k8s-initcontainer
build-k8s-initcontainer: check-language-arg
	eval $$(minikube docker-env --shell=bash) && \
		docker build -t e2e/newrelic-${INITCONTAINER_LANGUAGE}-init:e2e ${REPO_ROOT}/src/${INITCONTAINER_LANGUAGE}/

# Build local Kubernetes test app image
.PHONY: build-k8s-testapp
build-k8s-testapp: check-language-arg
	eval $$(minikube docker-env --shell=bash) && \
		docker build -t e2e/test-app-${INITCONTAINER_LANGUAGE}:e2e ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/

# Deploy and open Kubernetes test app in browser
.PHONY: k8s-test
k8s-test: build-k8s-initcontainer build-k8s-testapp check-language-arg
	helm uninstall test-deployment --ignore-not-found
	sleep 1
	helm install test-deployment ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/chart/
	sleep 3
	kubectl wait --for=condition=Ready -n default --all pods
	minikube service test-app-${INITCONTAINER_LANGUAGE}-service -n default

# View Kubernetes test app container logs
.PHONY: get-pods
get-pods:
	kubectl get pods -n default

# View Kubernetes test app container logs
.PHONY: k8s-logs-testapp
k8s-logs-testapp:
	kubectl logs $$(kubectl get pods -n default | grep test-app- | cut -d" " -f1)

# View Kubernetes test app container logs
.PHONY: k8s-logs-testapp
k8s-logs-operator:
	kubectl logs -n k8s-agents-operator $$(kubectl get pods -n k8s-agents-operator | grep k8s-agents-operator | cut -d" " -f1)


# Set up Azure environment, shared volume, and container registry
.PHONY: azure-env
azure-env:
	az login
	az group create --name cli-test-rg --location westus
	az containerapp env create --name cli-test-env --resource-group cli-test-rg --location westus
	az storage account create --resource-group cli-test-rg --name testcliappstorageaccount --location westus --kind StorageV2 --sku Standard_LRS --enable-large-file-share
	az storage share-rm create --resource-group cli-test-rg --storage-account testcliappstorageaccount --name testfilesharecli --quota 4096 --enabled-protocols SMB
	az containerapp env storage set --access-mode ReadWrite --azure-file-account-name testcliappstorageaccount --azure-file-account-key `az storage account keys list -n testcliappstorageaccount --query "[0].value" -o tsv --resource-group cli-test-rg` --azure-file-share-name testfilesharecli --storage-name instrumentation --name cli-test-env --resource-group cli-test-rg
	az acr create --resource-group cli-test-rg --name e2eazure --sku Standard --location westus --admin-enabled true
	az acr login --resource-group cli-test-rg --name e2eazure
	
# Build local Azure initcontainer image
.PHONY: build-azure-initcontainer
build-azure-initcontainer: check-language-arg
	docker build --tag newrelic-${INITCONTAINER_LANGUAGE}-init ${REPO_ROOT}/src/${INITCONTAINER_LANGUAGE}/ --platform linux/amd64

# Build local Azure test app image
.PHONY: build-azure-testapp
build-azure-testapp: check-language-arg
	docker build --tag test-app-${INITCONTAINER_LANGUAGE} ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/ --platform linux/amd64

# Deploy Azure test apps and init container
.PHONY: deploy-azure-images
deploy-azure-images: build-azure-initcontainer build-azure-testapp check-language-arg
	docker tag newrelic-${INITCONTAINER_LANGUAGE}-init e2eazure.azurecr.io/newrelic-${INITCONTAINER_LANGUAGE}-init:e2e
	docker push e2eazure.azurecr.io/newrelic-${INITCONTAINER_LANGUAGE}-init:e2e
	docker tag test-app-${INITCONTAINER_LANGUAGE} e2eazure.azurecr.io/test-app-${INITCONTAINER_LANGUAGE}:e2e
	docker push e2eazure.azurecr.io/test-app-${INITCONTAINER_LANGUAGE}:e2e

# Create container app
.PHONY: azure-container-app
azure-container-app: check-language-arg
	az containerapp create --name cli-test-container-app --resource-group cli-test-rg --environment cli-test-env --image e2eazure.azurecr.io/test-app-${INITCONTAINER_LANGUAGE}:e2e --min-replicas 1 --max-replicas 1 --target-port 8000 --ingress external --registry-server e2eazure.azurecr.io

# Set license key as a secret and set other environment variables
.PHONY: license_key_env_vars-azure
license_key_env_vars-azure:
	az containerapp secret set --name cli-test-container-app --resource-group cli-test-rg --secrets license-key=${NEW_RELIC_LICENSE_KEY} 
	# For testing, we will keep this as NEW_RELIC_K8S_OPERATOR_ENABLED, but right before releasing the Python Agent, we will change this to NEW_RELIC_AZURE_OPERATOR_ENABLED
	az containerapp update --name cli-test-container-app --resource-group cli-test-rg --set-env-vars "NEW_RELIC_HOST=staging-collector.newrelic.com" "NEW_RELIC_APP_NAME=Azure-E2E-tests" "NEW_RELIC_K8S_OPERATOR_ENABLED=true" "NEW_RELIC_LICENSE_KEY=secretref:license-key" "PYTHONPATH=/mnt/instrumentation"

# Update container app with new configuration
# This will use template file to do so
.PHONY: template-file-upload
template-file-upload:
	az containerapp update --name cli-test-container-app --resource-group cli-test-rg --yaml ${TEMPLATE_FILE}

# Delete the resource group and everything in it
.PHONY: azure-delete
azure-delete:
	az group delete --name cli-test-rg --yes --no-wait true


.PHONY: check-language-arg
check-language-arg:
ifeq ($(strip $(INITCONTAINER_LANGUAGE)),)
	@echo "Required variable INITCONTAINER_LANGUAGE not set. Either set it in the Makefile, or call make with \nINITCONTAINER_LANGUAGE=<language> make <target>"; exit 1
endif
