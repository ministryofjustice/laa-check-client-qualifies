#!/bin/bash
POD=$(kubectl -n laa-check-client-qualifies-uat get pods | grep -o "check-client-qualifies-laa-estimate-eligibility.*" | head -n1 | cut -d' ' -f 1)

echo "Finding pod"
echo "Connecting to $POD"
kubectl -n laa-check-client-qualifies-uat exec "$POD" -- rake db:version
cat << INSTRUCTIONS
Do you care about the current state of your dev DB? read on, otherwise skip to step 2

1. Take a backup of your current local dev database

2. Delete the current, local database

3. Restore the database
INSTRUCTIONS