#!/bin/bash
# Install the Chainloop CLI if not already present in the workshop image.
set -euo pipefail

chainloop config save \
  --control-plane api-cp.${INGRESS_DOMAIN}:443 \
  --artifact-cas api-cas.${INGRESS_DOMAIN}:443 \
  --insecure=false

