#!/bin/bash
# Install the Chainloop CLI if not already present in the workshop image.
set -euo pipefail

if ! command -v chainloop &>/dev/null; then
  echo "Installing Chainloop CLI..."
  mkdir -p ~/.local/bin
  curl -sfL https://dl.chainloop.dev/cli/install.sh | bash -s -- --path ~/.local/bin
else
  echo "Chainloop CLI already installed: $(chainloop version --short 2>/dev/null || chainloop version)"
fi

chainloop config save \
  --control-plane api-cp.${INGRESS_DOMAIN}:443 \
  --artifact-cas api-cas.${INGRESS_DOMAIN}:443 \
  --insecure=false

