#!/bin/bash
# Reproduce the Workshop A01 end-state for this A02 session:
# - Create the workflow and contract in Chainloop (as A01 would have left them)
# - Set CHAINLOOP_TOKEN and CHAINLOOP_WORKFLOW as GitHub Actions repository secrets
set -euo pipefail

# Source the exported variables from previous setup scripts
source /etc/profile.d/chainloop-env.sh
source /etc/profile.d/github-env.sh

WORKFLOW_NAME="${SESSION_NAMESPACE}-demo"
CONTRACT_NAME="${SESSION_NAMESPACE}-contract"

# ── Create workflow and contract in Chainloop ────────────────────────────────
chainloop workflow create \
  --name "$WORKFLOW_NAME" \
  --project "workshop" 2>/dev/null || echo "Workflow already exists, continuing."

chainloop workflow contract create \
  --name "$CONTRACT_NAME" \
  --schema /home/eduk8s/exercises/chainloop/workflow-contract-v2.yaml 2>/dev/null \
  || echo "Contract already exists, continuing."

chainloop workflow update \
  --name "$WORKFLOW_NAME" \
  --contract "$CONTRACT_NAME" 2>/dev/null || true

# ── Set Chainloop secrets on the GitHub repository ───────────────────────────
# Use the admin PAT (set as GH_TOKEN in github-env.sh) to set secrets.
# The learner's GH_TOKEN (user-pat) may not have secrets:write; use admin PAT.
GITHUB_ADMIN_PAT=$(kubectl get secret github-pats \
  -o jsonpath='{.data.admin-pat}' 2>/dev/null | base64 -d)

GH_TOKEN="${GITHUB_ADMIN_PAT}" gh secret set CHAINLOOP_TOKEN \
  --body "${CHAINLOOP_TOKEN}" \
  --repo "${GITHUB_ORG}/${GITHUB_REPO_NAME}"

GH_TOKEN="${GITHUB_ADMIN_PAT}" gh secret set CHAINLOOP_WORKFLOW \
  --body "${WORKFLOW_NAME}" \
  --repo "${GITHUB_ORG}/${GITHUB_REPO_NAME}"

echo "A01 end-state reproduced: workflow=${WORKFLOW_NAME}, contract=${CONTRACT_NAME}"
echo "GitHub Actions secrets CHAINLOOP_TOKEN and CHAINLOOP_WORKFLOW are set."
