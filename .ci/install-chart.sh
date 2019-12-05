#!/usr/bin/env bash
#
# install charts in kubernetes kind
#

set -o errexit
set -o pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKDIR="/workdir"
CLUSTER_NAME="chart-testing"
DOCKER_NAME="ct"

echo -e "\\nTesting in Kubernetes ${K8S_VERSION}\\n"

run_ct_container() {
    echo "Running ${DOCKER_NAME} container..."

    docker container run --rm --interactive --detach --network host --name "${DOCKER_NAME}" \
        --volume "${REPO_ROOT}/.circleci/ct.yaml:/etc/ct/ct.yaml" \
        --volume "${REPO_ROOT}:${WORKDIR}" \
        --workdir ${WORKDIR} \
        "${CHART_TESTING_IMAGE}:${CHART_TESTING_TAG}" \
        cat
    echo
}

cleanup() {
    echo "Removing ${DOCKER_NAME} container..."

    docker container kill "${DOCKER_NAME}" > /dev/null 2>&1

    echo 'Done!'
}

docker_exec() {
    docker container exec --interactive ct "$@"
}

create_kind_cluster() {
    echo 'Installing kind...'

    curl -sSLo kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64"
    chmod +x kind
    sudo mv kind /usr/local/bin/kind

    kind create cluster --name "${CLUSTER_NAME}" --config "${REPO_ROOT}"/.circleci/kind-config.yaml --image "kindest/node:${K8S_VERSION}"

    docker_exec mkdir -p /root/.kube

    echo 'Copying kubeconfig to container...'
    local KUBECONFIG
    KUBECONFIG="$(kind get kubeconfig-path --name "${CLUSTER_NAME}")"
    docker cp "${KUBECONFIG}" "${DOCKER_NAME}":/root/.kube/config

    docker_exec kubectl cluster-info
    echo

    echo -n 'Waiting for cluster to be ready...'
    until ! grep --quiet 'NotReady' <(docker_exec kubectl get nodes --no-headers); do
        printf '.'
        sleep 1
    done

    echo '✔︎'
    echo

    docker_exec kubectl get nodes
    echo

    echo 'Cluster ready!'
    echo
}

install_tiller() {
    echo 'Installing Tiller...'
    docker_exec kubectl --namespace kube-system create sa tiller
    docker_exec kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    docker_exec helm init --service-account tiller --upgrade --wait
    echo
}

install_hostpath-provisioner() {
    # kind doesn't support Dynamic PVC provisioning yet, this is one way to get it working
    # https://github.com/rimusz/charts/tree/master/stable/hostpath-provisioner

    echo 'Installing hostpath-provisioner...'

    # Remove default storage class. Will be recreated by hostpath -provisioner
    docker_exec kubectl delete storageclass standard

    docker_exec helm repo add rimusz https://charts.rimusz.net
    docker_exec helm repo update
    docker_exec helm install rimusz/hostpath-provisioner --name hostpath-provisioner --namespace kube-system --wait
    echo
}

add_helm_repos() {
    docker_exec helm repo add kiwigrid https://kiwigrid.github.io/
    docker_exec helm repo update
    echo
}

install_charts() {
    docker_exec "${DOCKER_NAME}" install --config=${WORKDIR}/.circleci/ct.yaml
    echo
}

cleanup_cluster() {
if [ -n "$(command -v kind)" ]; then
    for CLUSTER in $(kind get clusters); do
    echo "delete old cluster ${CLUSTER}"
    kind delete cluster --name "${CLUSTER}"
    done
fi
}

main() {
    cleanup_cluster
    create_kind_cluster
    install_tiller
    install_hostpath-provisioner
    add_helm_repos
    install_charts
}

run_ct_container
trap cleanup EXIT

main
