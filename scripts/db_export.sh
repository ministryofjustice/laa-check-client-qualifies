#!/bin/bash
POD=$(kubectl -n laa-check-client-qualifies-uat get pods | grep -o "check-client-qualifies-laa-estimate-eligibility.*" | head -n1 | cut -d' ' -f 1)

case "$1" in
"staging")
  environment=$1
  POD=$(kubectl -n laa-check-client-qualifies-staging get pods | grep -o "check-client-qualifies-laa-estimate-eligibility.*" | head -n1 | cut -d' ' -f 1)
  ;;
"production")
  environment=$1
  POD=$(kubectl -n laa-check-client-qualifies-production get pods | grep -o "check-client-qualifies-laa-estimate-eligibility.*" | head -n1 | cut -d' ' -f 1)
 ;;
"")
  echo "Usage: db_export.sh [environment]
Where:
environment  [staging, production or a branch name, i.e. el-1234]"
  exit 1
  ;;
*)
  environment='uat'
  POD=$(kubectl -n laa-check-client-qualifies-$environment get pods | grep -o -m4 "$1.*" | head -n1 | cut -d' ' -f 1)
esac

echo "Finding pod"
echo "Connecting to $POD"
kubectl -n laa-check-client-qualifies-$environment exec "$POD" -- rake db:export
kubectl -n laa-check-client-qualifies-$environment cp --retries=10 "laa-check-client-qualifies-$environment/$POD:tmp/temp.sql.gz" "./tmp/$environment.anon.sql.gz"
gunzip "./tmp/$environment.anon.sql.gz"
cat << INSTRUCTIONS
Do you care about the current state of your dev DB? read on, otherwise skip to step 2

1. Take a backup of your current local dev database

2. Delete the current, local database

3. Restore the database
INSTRUCTIONS