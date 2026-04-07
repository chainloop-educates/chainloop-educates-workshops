#!/bin/bash
# Read the pre-provisioned Chainloop token from the K8s secret and export it.
# For this PoC, the admin token is used directly as the session token.
set -euo pipefail

CHAINLOOP_TOKEN=$(kubectl get secret chainloop-admin-token \
  -o jsonpath='{.data.token}' | base64 -d)

if [ -z "$CHAINLOOP_TOKEN" ]; then
  echo "ERROR: Could not read Chainloop token from secret 'chainloop-admin-token'." >&2
  exit 1
fi

cat > /etc/profile.d/chainloop-env.sh <<EOF
export CHAINLOOP_TOKEN="${CHAINLOOP_TOKEN}"
export DO_NOT_TRACK=1
EOF

echo "Chainloop token configured."
