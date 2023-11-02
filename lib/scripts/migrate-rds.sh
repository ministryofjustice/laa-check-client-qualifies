#!/bin/bash

# This script migrates RDS data from one namespace to another
# It requires cloud-platform CLI and jq JSON processor to be installed.
# Call with `./migrate-rds.sh old-namespace new-namespace`

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

# Retrieve credentials from k8s via the Cloud platform CLI
echo "1/14 Retrieving credentials from Cloud Platform..."
OLD_RDS_NAME=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_name' | tr -d '"')
OLD_RDS_HOST=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.rds_instance_address' | tr -d '"')
OLD_RDS_USERNAME=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_username' | tr -d '"')
OLD_RDS_PASSWORD=$(cloud-platform decode-secret -n $OLD_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_password' | tr -d '"')
NEW_RDS_NAME=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_name' | tr -d '"')
NEW_RDS_HOST=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.rds_instance_address' | tr -d '"')
NEW_RDS_USERNAME=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_username' | tr -d '"')
NEW_RDS_PASSWORD=$(cloud-platform decode-secret -n $NEW_NAMESPACE -s rds-postgresql-instance-output --skip-version-check | jq '.data.database_password' | tr -d '"')

if [[ ! $OLD_RDS_NAME ]]; then
  echo "Could not retrieve old namespace database name"
  exit 1
fi

if [[ ! $OLD_RDS_HOST ]]; then
  echo "Could not retrieve old namespace database host"
  exit 1
fi

if [[ ! $OLD_RDS_USERNAME ]]; then
  echo "Could not retrieve old namespace database username"
  exit 1
fi

if [[ ! $OLD_RDS_PASSWORD ]]; then
  echo "Could not retrieve old namespace database password"
  exit 1
fi

if [[ ! $NEW_RDS_NAME ]]; then
  echo "Could not retrieve new namespace database name"
  exit 1
fi

if [[ ! $NEW_RDS_HOST ]]; then
  echo "Could not retrieve new namespace database host"
  exit 1
fi

if [[ ! $NEW_RDS_USERNAME ]]; then
  echo "Could not retrieve new namespace database username"
  exit 1
fi

if [[ ! $NEW_RDS_PASSWORD ]]; then
  echo "Could not retrieve new namespace database password"
  exit 1
fi


STANDARD_RDS_PORT=5432
OLD_RDS_LOCAL_PORT=5656
NEW_RDS_LOCAL_PORT=5657
PORT_FORWARD_POD_NAME=rds-port-forward-pod

# Create port forwarding pods
create_pods() {
  echo "2/14 Creating port forwarding pod in old namespace..."
  kubectl \
    -n $OLD_NAMESPACE \
    run $PORT_FORWARD_POD_NAME \
    --image=ministryofjustice/port-forward \
    --port=$STANDARD_RDS_PORT \
    --env="REMOTE_HOST=$OLD_RDS_HOST" \
    --env="LOCAL_PORT=$STANDARD_RDS_PORT" \
    --env="REMOTE_PORT=$STANDARD_RDS_PORT" || { echo "Failed to create pod in old namespace"; return 1; }

  echo "3/14 Creating port forwarding pod in new namespace..."
  kubectl \
    -n $NEW_NAMESPACE \
    run $PORT_FORWARD_POD_NAME \
    --image=ministryofjustice/port-forward \
    --port=$STANDARD_RDS_PORT \
    --env="REMOTE_HOST=$NEW_RDS_HOST" \
    --env="LOCAL_PORT=$STANDARD_RDS_PORT" \
    --env="REMOTE_PORT=$STANDARD_RDS_PORT" || { echo "Failed to create pod in new namespace"; return 1; }

  echo "4/14 Waiting 10 seconds for pods to be ready..."
  sleep 10
  return 0
}

# Start running the port forwarding ports
run_pods() {
  echo "5/14 Starting port forwarding pod in old namespace..."
  kubectl -n $OLD_NAMESPACE port-forward $PORT_FORWARD_POD_NAME $OLD_RDS_LOCAL_PORT:$STANDARD_RDS_PORT &

  OLD_PORT_FORWARD_PID=$!

  echo "6/14 Waiting 3 seconds to see if port forwarding fails early in old namespace..."
  sleep 3
  if [[ ! $(ps -p $OLD_PORT_FORWARD_PID -o pid=) ]]; then
    echo "Port forwarding in old namespace failed"
    return 1
  fi

  echo "7/14 Starting port forwarding pod in new namespace..."
  kubectl -n $NEW_NAMESPACE port-forward $PORT_FORWARD_POD_NAME $NEW_RDS_LOCAL_PORT:$STANDARD_RDS_PORT &

  NEW_PORT_FORWARD_PID=$!

  echo "8/14 Waiting 3 seconds to see if port forwarding fails early in new namespace..."
  sleep 3
  if [[ ! $(ps -p $NEW_PORT_FORWARD_PID -o pid=) ]]; then
  echo "Port forwarding in new namespace failed"
    return 1
  fi

  return 0
}

# Migrate data
migrate_db() {
  echo "9/14 Storing old database back-up locally..."
  pg_dump \
    -O \
    -w \
    -x \
    -f ~/Downloads/old_db_backup_for_migration.sql postgres://$OLD_RDS_USERNAME:$OLD_RDS_PASSWORD@localhost:$OLD_RDS_LOCAL_PORT/$OLD_RDS_NAME || { echo "Old database backup failed"; return 1; }

  echo "10/14 Cleaning new database..."
  psql \
    -q \
    -d "postgres://$NEW_RDS_USERNAME:$NEW_RDS_PASSWORD@localhost:$NEW_RDS_LOCAL_PORT/$NEW_RDS_NAME" \
    -c "drop schema public cascade" || { echo "New database clean-up failed"; return 1; }

  echo "11/14 Preparing new database..."
  psql \
    -q \
    -d "postgres://$NEW_RDS_USERNAME:$NEW_RDS_PASSWORD@localhost:$NEW_RDS_LOCAL_PORT/$NEW_RDS_NAME" \
    -c "create schema public" || { echo "New database preparation failed"; return 1; }

  echo "12/14 Restoring old database to new database..."
  psql \
    -q \
    -P pager=off \
    -d "postgres://$NEW_RDS_USERNAME:$NEW_RDS_PASSWORD@localhost:$NEW_RDS_LOCAL_PORT/$NEW_RDS_NAME" \
    -f ~/Downloads/old_db_backup_for_migration.sql || { echo "Database migration failed"; return 1; }

  return 0
}

delete_pods() {
  echo "14/14 Cleaning up..."
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

delete_local_db_copy() {
  echo "13/14 Cleaning up..."
  if test -f ~/Downloads/old_db_backup_for_migration.sql; then
    echo "--> Deleting db backup file"
    rm -f ~/Downloads/old_db_backup_for_migration.sql
  fi
}

fail_gracefully() {
  delete_pods
  delete_local_db_copy
  echo "Migration did not complete successfully"
  exit 1
}

create_pods || fail_gracefully
run_pods || fail_gracefully
migrate_db || fail_gracefully
delete_local_db_copy
delete_pods

echo "Migration completed successfully."
