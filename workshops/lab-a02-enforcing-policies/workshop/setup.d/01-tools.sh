#!/bin/bash
# Install Chainloop CLI and Syft if not already present.
set -euo pipefail

if ! command -v syft &>/dev/null; then
  echo "Installing Syft..."
  curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
else
  echo "Syft already installed."
fi
