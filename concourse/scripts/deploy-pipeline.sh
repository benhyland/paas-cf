#!/bin/bash
set -eu

SCRIPT=$0

usage() {
   cat <<EOF
Usage:

   $SCRIPT <env> <pipeline> <config> <varsfile>

Being:

   env			environment name
   pipeline		pipeline name
   config		config for the pipeline
   varsfile     concourse variables to pass to the pipeline

EOF
   exit 1
}

if [ $# -lt 4 ]; then
   usage
fi

env=$1; shift
pipeline=$1; shift
config=$1; shift
varsfile=$1; shift

echo "Concourse API target ${FLY_TARGET}"
echo "Deployment ${env}"
echo "Pipeline ${pipeline}"
echo "Config file ${config}"

yes y | \
   $FLY_CMD -t "${FLY_TARGET}" \
   set-pipeline \
   --config "${config}" \
   --pipeline "${pipeline}" \
   --load-vars-from "${varsfile}"

$FLY_CMD -t "${FLY_TARGET}" \
  unpause-pipeline \
  --pipeline "${pipeline}"
