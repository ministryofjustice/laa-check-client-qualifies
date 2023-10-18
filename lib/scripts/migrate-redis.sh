#!/bin/bash

# This script migrates redis data from one namespace to another
# It requires riot and cloud-platform CLI to be installed.
# Call with `./migrate-redis.sh old-namespace new-namespace`

# These settings cause the script to error out if something goes wrong.
set -eo pipefail

OLD_NAMESPACE=$1
NEW_NAMESPACE=$2

if [[ ! $OLD_NAMESPACE ]]; then
  echo "Must provide old namespace"
  exit 1
fi

if [[ ! $NEW_NAMESPACE ]]; then
  echo "Must provide new namespace"
  exit 1
fi

# Verify RIOT is installed
echo "1/11 Verifying RIOT is installed..."
riot --version > /dev/null

# Retrieve credentials from k8s via the Cloud platform CLI
echo "2/11 Retrieving credentials from Cloud Platform..."
OLD_REDIS_HOST=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s laa-estimate-financial-eligibility-elasticache-instance-output --skip-version-check | jq '.data.primary_endpoint_address')
OLD_REDIS_PASSWORD=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s laa-estimate-financial-eligibility-elasticache-instance-output --skip-version-check | jq '.data.auth_token' | tr -d '"')
NEW_REDIS_HOST=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s laa-check-client-qualifies-elasticache-instance-output --skip-version-check | jq '.data.primary_endpoint_address')
NEW_REDIS_PASSWORD=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s laa-check-client-qualifies-elasticache-instance-output --skip-version-check | jq '.data.auth_token' | tr -d '"')

if [[ ! $OLD_REDIS_HOST ]]; then
  echo "Could not retrieve old namespace hostname"
  exit 1
fi

if [[ ! $OLD_REDIS_PASSWORD ]]; then
  echo "Could not retrieve old namespace password"
  exit 1
fi

if [[ ! $NEW_REDIS_HOST ]]; then
  echo "Could not retrieve new namespace hostname"
  exit 1
fi

if [[ ! $NEW_REDIS_PASSWORD ]]; then
  echo "Could not retrieve new namespace password"
  exit 1
fi


STANDARD_REDIS_PORT=6379
OLD_REDIS_LOCAL_PORT=6380
NEW_REDIS_LOCAL_PORT=6381
PORT_FORWARD_POD_NAME=redis-port-forward-pod

# Create port forwarding pods
create_pods() {
  echo "3/11 Creating port forwarding pod in old namespace..."
  kubectl \
    -n $OLD_NAMESPACE \
    run $PORT_FORWARD_POD_NAME \
    --image=ministryofjustice/port-forward \
    --port=$STANDARD_REDIS_PORT \
    --env="REMOTE_HOST=$OLD_REDIS_HOST" \
    --env="LOCAL_PORT=$STANDARD_REDIS_PORT" \
    --env="REMOTE_PORT=$STANDARD_REDIS_PORT" || { echo "Failed to create pod in old namespace"; return 1; }

  echo "4/11 Creating port forwarding pod in new namespace..."
  kubectl \
    -n $NEW_NAMESPACE \
    run $PORT_FORWARD_POD_NAME \
    --image=ministryofjustice/port-forward \
    --port=$STANDARD_REDIS_PORT \
    --env="REMOTE_HOST=$NEW_REDIS_HOST" \
    --env="LOCAL_PORT=$STANDARD_REDIS_PORT" \
    --env="REMOTE_PORT=$STANDARD_REDIS_PORT" || { echo "Failed to create pod in new namespace"; return 1; }

  echo "5/11 Waiting 10 seconds for pods to be ready..."
  sleep 10
  return 0
}

# Start running the port forwarding ports
run_pods() {
  echo "6/11 Starting port forwarding pod in old namespace..."
  kubectl -n $OLD_NAMESPACE port-forward $PORT_FORWARD_POD_NAME $OLD_REDIS_LOCAL_PORT:$STANDARD_REDIS_PORT &

  OLD_PORT_FORWARD_PID=$!

  echo "7/11 Waiting 3 seconds to see if port forwarding fails early in old namespace..."
  sleep 3
  if [[ ! $(ps -p $OLD_PORT_FORWARD_PID -o pid=) ]]; then
    echo "Port forwarding in old namespace failed"
    return 1
  fi

  echo "8/11 Starting port forwarding pod in new namespace..."
  kubectl -n $NEW_NAMESPACE port-forward $PORT_FORWARD_POD_NAME $NEW_REDIS_LOCAL_PORT:$STANDARD_REDIS_PORT &

  NEW_PORT_FORWARD_PID=$!

  echo "9/11 Waiting 3 seconds to see if port forwarding fails early in new namespace..."
  sleep 3
  if [[ ! $(ps -p $NEW_PORT_FORWARD_PID -o pid=) ]]; then
  echo "Port forwarding in new namespace failed"
    return 1
  fi

  return 0
}

# Run the RIOT tool that will push data from old to new in batches
run_riot() {
  echo "10/11 Running riot..."
  riot -h localhost -p $OLD_REDIS_LOCAL_PORT --pass $OLD_REDIS_PASSWORD --tls --tls-verify NONE \
      replicate \
      -h localhost -p $NEW_REDIS_LOCAL_PORT --pass $NEW_REDIS_PASSWORD --tls --tls-verify NONE --batch 10000 \
      --scan-count 10000 \
      --threads 4 \
      --read-threads 4 \
      --read-batch 500 \
      --read-queue 2000 \
      --read-pool 4  || { echo "Riot reported an error."; return 1; }
  return 0
}


delete_pods() {
  echo "11/11 Cleaning up..."
  if [[ $OLD_PORT_FORWARD_PID ]]; then
    if [[ $(ps -p $OLD_PORT_FORWARD_PID -o pid=) ]]; then
      echo "--> Killing port forwarding process in old namespace"
      kill $OLD_PORT_FORWARD_PID
    fi
  fi

  if [[ $NEW_PORT_FORWARD_PID ]]; then
    if [[ $(ps -p $NEW_PORT_FORWARD_PID -o pid=) ]]; then
      echo "--> Killing port forwarding process in new namespace"
      kill $NEW_PORT_FORWARD_PID
    fi
  fi

  echo "--> Deleting pod from old namespace"
  kubectl delete pod $PORT_FORWARD_POD_NAME -n $OLD_NAMESPACE > /dev/null &

  echo "--> Deleting pod from new namespace"
  kubectl delete pod $PORT_FORWARD_POD_NAME -n $NEW_NAMESPACE > /dev/null &
}

fail_gracefully() {
  delete_pods
  echo "Migration did not complete successfully"
  exit 1
}

create_pods || fail_gracefully
run_pods || fail_gracefully
run_riot || fail_gracefully
delete_pods

echo "Migration completed successfully."
