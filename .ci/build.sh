#!/usr/bin/env bash
#
# ci with chart-testing & kind
#

set -o errexit
set -o nounset
set -o pipefail

CHART_TESTING_IMAGE="quay.io/helmpack/chart-testing"
CHART_TESTING_TAG="v2.0.1"
INSTALL="no"
KIND_DOCKER_NAME="kind-1-control-plane"
KUBERNETES_VERSIONS=('v1.11.3' 'v1.12.2')
LINT="yes"
REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKDIR="/workdir"


lint() {
  docker run -it --rm -v "${REPO_ROOT}:${WORKDIR}" --workdir "${WORKDIR}" "${CHART_TESTING_IMAGE}:${CHART_TESTING_TAG}" ct lint --config="${WORKDIR}/.ci/ct-config.yaml" --lint-conf="${WORKDIR}/.ci/lint-conf.yaml" --chart-yaml-schema="${WORKDIR}/.ci/chart-schema.yaml"
}

run_kind() {

    echo "Get kind binary..."
    docker run --rm -it -v "$(pwd)":/go/bin golang go get sigs.k8s.io/kind && chmod +x kind && sudo mv kind /usr/local/bin/

    echo "Download kubectl..."
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/"${K8S_VERSION}"/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    echo

    echo "Cleanup old kind clusters ..."
    cleanup

    echo "Create Kubernetes cluster with kind..."
    kind create cluster --image=kindest/node:"$K8S_VERSION"

    echo "Export kubeconfig..."
    # shellcheck disable=SC2155
    export KUBECONFIG="$(kind get kubeconfig-path)"
    echo

    echo "Ensure the apiserver is responding..."
    kubectl cluster-info
    echo

    echo "Wait for Kubernetes to be up and ready..."
    JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done
    echo
}

install_tiller() {
    # Install Tiller with RBAC
    kubectl -n kube-system create sa tiller
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    docker exec "$config_container_id" helm init --service-account tiller
    echo "Wait for Tiller to be up and ready..."
    until kubectl -n kube-system get pods 2>&1 | grep -w "tiller-deploy"  | grep -w "1/1"; do sleep 1; done
    echo
}

install_hostpath_provisioner() {
     # kind doesn't support Dynamic PVC provisioning yet, this one of ways to get it working
     # https://github.com/rimusz/charts/tree/master/stable/hostpath-provisioner

     # delete the default storage class
     kubectl delete storageclass standard

     echo "Install Hostpath Provisioner..."
     docker exec "$config_container_id" helm repo add rimusz https://charts.rimusz.net
     docker exec "$config_container_id" helm repo update
     docker exec "$config_container_id" helm upgrade --install hostpath-provisioner --namespace kube-system rimusz/hostpath-provisioner
     echo
}

cleanup() {
  for CLUSTER in $(kind get clusters); do
    kind delete cluster "${CLUSTER}"
  done
}

main() {
    echo "Starting kind ..."
    echo
    run_kind

    local config_container_id
    config_container_id=$(docker run -it -d -v "${REPO_ROOT}:${WORKDIR}" --workdir "${WORKDIR}" "$CHART_TESTING_IMAGE:$CHART_TESTING_TAG" cat)

    # shellcheck disable=SC2064
    trap "docker rm -f $config_container_id > /dev/null" EXIT

    # Get kind container IP
    kind_container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${KIND_DOCKER_NAME}")
    # Copy kubeconfig file
    docker exec "$config_container_id" mkdir /root/.kube
    docker cp "$KUBECONFIG" "$config_container_id:/root/.kube/config"
    # Update in kubeconfig localhost to kind container IP
    docker exec "$config_container_id" sed -i "s/localhost/$kind_container_ip/g" /root/.kube/config

    # Install Tiller with RBAC
    install_tiller

    # Install hostpath-provisioner for Dynammic PVC provisioning
    install_hostpath_provisioner

    # shellcheck disable=SC2086
    docker exec "$config_container_id" ct install --config=${WORKDIR}/.ci/ct-config.yaml

    echo "Done Testing!"
}

if [ "${LINT}" == "yes" ]; then
  lint
fi

if [ "${INSTALL}" == "yes" ]; then
  for K8S_VERSION in "${KUBERNETES_VERSIONS[@]}"; do
    echo -e "\nTesting in Kubernetes ${K8S_VERSION}\n"
    main
  done
fi
