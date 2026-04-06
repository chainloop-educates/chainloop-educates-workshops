#!/bin/bash
# Install Chainloop CLI and Syft if not already present.
set -euo pipefail

if ! command -v chainloop &>/dev/null; then
  echo "Installing Chainloop CLI..."
  curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | bash -s -- --path /usr/local/bin
else
  echo "Chainloop CLI already installed."
fi

if ! command -v syft &>/dev/null; then
  echo "Installing Syft..."
  curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
else
  echo "Syft already installed."
fi
