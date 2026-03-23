#!/bin/bash

# shellcheck disable=SC1091

################# standard init #################

# 8 seconds is usually enough time for the average user to realize they foobar
export SLEEP_SECONDS=8

check_shell(){
  [ -n "$BASH_VERSION" ] && return
  echo -e "${ORANGE}WARNING: These scripts are ONLY tested in a bash shell${NC}"
  sleep "${SLEEP_SECONDS:-8}"
}

check_git_root(){
  if [ -d .git ] && [ -d scripts ]; then
    GIT_ROOT=$(pwd)
    export GIT_ROOT
    echo "GIT_ROOT:   ${GIT_ROOT}"
  else
    echo "Please run this script from the root of the git repo"
    exit
  fi
}

get_script_path(){
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  echo "SCRIPT_DIR: ${SCRIPT_DIR}"
}

check_shell
check_git_root
get_script_path

# shellcheck source=/dev/null
. "${SCRIPT_DIR}/functions.sh"

validate_cli(){
  echo ""
  echo "Validating command requirements..."
  bin_check oc
  bin_check jq
  echo ""
}

help(){
  loginfo "This script installs RHOAI and other dependencies"
  loginfo "Usage: $(basename "$0") -s <step-number>"
  loginfo "Options:"
  loginfo " -h, --help   usage"
  loginfo " -s, --step   step number (required)"
  loginfo "        0       - Install prerequisites"
  loginfo "        1       - Add model registry"
  loginfo "        2       - Configure model catalog"
  return 0
}

while getopts ":h:s:" flag; do
  case $flag in
    h) help ;;
    s) s=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&1; exit 1 ;;
  esac
done

step_0(){
  logbanner "Install prerequisites"

  retry oc apply -f "${GIT_ROOT}"/configs/00/web-terminal-subscription.yaml

  retry INSTALL_PLAN=$(oc get installplan -n openshift-operators -o json | jq '.items[] | select(.spec.clusterServiceVersionNames[] | contains  ("web-terminal")) | .metadata.name' | tr -d \")
  retry oc patch installplan $INSTALL_PLAN \
    --namespace openshift-operators \
    --type merge \
    --patch '{"spec":{"approved":true}}'

  retry oc apply -f "${GIT_ROOT}"/configs/00/

  validate_cli || echo "!!!NOTICE: you are missing cli tools needed!!!"
}

step_1(){
  retry oc apply -f configs/01/
}

step_2(){
    mkdir -p scratch
    POD_NAME=$(oc get pods -n rhoai-model-registries -l app.kubernetes.io/name=model-catalog -o name)
    oc exec -n rhoai-model-registries $POD_NAME -c catalog -- cat /shared-data/validated-models-catalog.yaml > scratch/validated-models-catalog.yaml
    yq '.models.[] | select(.name == "RedHatAI/gpt-oss-120b")' scratch/validated-models-catalog.yaml > scratch/new-model.yaml
    yq -i '.name = "gpt-oss-20b-essential"' scratch/new-model.yaml
    yq -i '.provider = "OpenAI by way of Red Hat"' scratch/new-model.yaml
    yq -i '.description = "This is a Red Hat packaged version of gpt-oss that streamlines the model architecture to just the essential files necessary to run the model in vLLM."' scratch/new-model.yaml
    yq -i '.artifacts[0].uri = "oci://registry.redhat.io/rhai/modelcar-gpt-oss-20b-essential:3.0"' scratch/new-model.yaml
    touch scratch/model-for-configmap.yaml
    yq -i '.source = "Organization AI"' scratch/model-for-configmap.yaml
    yq -i '.models = [load("scratch/new-model.yaml")]' scratch/model-for-configmap.yaml
    oc get configmap model-catalog-sources -n rhoai-model-registries -o yaml > scratch/model-catalog-sources.yaml
    cp scratch/model-catalog-sources.yaml scratch/new-model-catalog-sources.yaml
    yq -i '.data."sources.yaml" = load_str("configs/02/sources.yaml")' scratch/new-model-catalog-sources.yaml
    yq -i '.data."my-ai-catalog.yaml" = load_str("scratch/model-for-configmap.yaml")' scratch/new-model-catalog-sources.yaml
    oc replace configmap -n rhoai-model-registries -f scratch/new-model-catalog-sources.yaml
    oc rollout restart deployment/model-catalog -n rhoai-model-registries
}

setup(){

  if [ -z "$s" ]; then
      logerror "Step number is required"
      help
  fi

  if [ "$s" = "0" ] ; then
      loginfo "Running step 0"
      step_0
      exit 0
  fi

  for (( i=1; i <= s; i++ ))
  do
      loginfo "Running step $i"
      echo ""
      eval "step_$i"
  done
}

is_sourced || setup