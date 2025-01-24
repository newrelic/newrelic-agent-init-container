# Constants
MAKEFILE_DIR:=$(dir $(realpath $(firstword ${MAKEFILE_LIST})))
REPO_ROOT:=$(realpath ${MAKEFILE_DIR}../)

# Initcontainer language under test
INITCONTAINER_LANGUAGE:=${INITCONTAINER_LANGUAGE}

# Path to the local copy of the repo newrelic/k8s-agents-operator.
# Only required if building and testing the operator from source.
LOCAL_OPERATOR_REPO_PATH:=${REPO_ROOT}/../k8s-agents-operator

.PHONY: default
default: all

# Install all dependencies and run tests
.PHONY: all
all: minikube operator test

# Start minikube
.PHONY: minikube
minikube:
	minikube start --driver=docker
	helm repo update

# Install official k8s-agents-operator repo
.PHONY: operator
operator:
	helm uninstall k8s-agents-operator --ignore-not-found
	helm repo add k8s-agents-operator https://newrelic.github.io/k8s-agents-operator
	helm upgrade --install k8s-agents-operator k8s-agents-operator/k8s-agents-operator \
		--set=licenseKey=${NEW_RELIC_LICENSE_KEY} \
		--set=controllerManager.manager.image.version=edge
	sleep 5
	kubectl wait --for=condition=Ready pods $$(kubectl get pods | grep k8s-agents-operator | cut -d" " -f1)

# Build and install local copy of k8s-agents-operator
.PHONY: operator-local
operator-local:
	eval $$(minikube docker-env --shell=bash) && \
		docker build ${LOCAL_OPERATOR_REPO_PATH}/ -t e2e/k8s-agents-operator:e2e
	helm uninstall k8s-agents-operator --ignore-not-found
	sleep 1
	helm upgrade --install k8s-agents-operator ${LOCAL_OPERATOR_REPO_PATH}/charts/k8s-agents-operator/ \
		--set=licenseKey=${NEW_RELIC_LICENSE_KEY} \
		--set=newRelicHost=${NEW_RELIC_HOST} \
		--set=controllerManager.manager.image.pullPolicy=Never \
		--set=controllerManager.manager.image.repository=e2e/k8s-agents-operator \
		--set=controllerManager.manager.image.version=e2e
	sleep 30
	kubectl wait --for=condition=Ready pods $$(kubectl get pods | grep k8s-agents-operator | cut -d" " -f1)

# Set license key in default namespace
.PHONY: license_key_secret
license_key_secret:
	kubectl delete secret newrelic-key-secret --ignore-not-found
	kubectl create secret generic newrelic-key-secret \
		--from-literal="new_relic_license_key=${NEW_RELIC_LICENSE_KEY}"

# Build local initcontainer image
.PHONY: build-initcontainer
build-initcontainer: check-language-arg
	eval $$(minikube docker-env --shell=bash) && \
		docker build -t e2e/newrelic-${INITCONTAINER_LANGUAGE}-init:e2e ${REPO_ROOT}/src/${INITCONTAINER_LANGUAGE}/

# Build local test app image
.PHONY: build-testapp
build-testapp: check-language-arg
	eval $$(minikube docker-env --shell=bash) && \
		docker build -t e2e/test-app-${INITCONTAINER_LANGUAGE}:e2e ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/

# Deploy and open test app in browser
.PHONY: test
test: build-initcontainer build-testapp check-language-arg
# helm uninstall test-deployment --ignore-not-found
# sleep 5
# helm install test-deployment ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/chart/
# sleep 5
# kubectl delete pods $$(kubectl get pods -n default | grep test-app- | cut -d" " -f1)
# sleep 5
# helm install --force test-deployment ${REPO_ROOT}/tests/${INITCONTAINER_LANGUAGE}/chart/
# sleep 5
	
	kubectl wait --for=condition=Ready -n default --all pods
# If yq is installed, check for the initcontainer to be visible on the pod spec
	command -v yq && kubectl get pods --output yaml | yq '.items[].spec.initContainers[].name' | grep -q "newrelic-instrumentation-" || $$(echo "Operator failed to attach initcontainer." >&2; exit 1)
	minikube service test-app-${INITCONTAINER_LANGUAGE}-service -n default

# View test app container logs
.PHONY: get-pods
get-pods:
	kubectl get pods -n default

# View test app container logs
.PHONY: logs-testapp
logs-testapp:
	kubectl logs $$(kubectl get pods -n default | grep test-app- | cut -d" " -f1)

# View test app container logs
.PHONY: logs-operator
logs-operator:
	kubectl logs $$(kubectl get pods | grep k8s-agents-operator | cut -d" " -f1)

.PHONY: check-language-arg
check-language-arg:
ifeq ($(strip $(INITCONTAINER_LANGUAGE)),)
	@echo "Required variable INITCONTAINER_LANGUAGE not set. Either set it in the Makefile, or call make with \nINITCONTAINER_LANGUAGE=<language> make <target>"; exit 1
endif
