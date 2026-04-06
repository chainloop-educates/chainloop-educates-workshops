#!/bin/bash
# Set up the GitHub repository for this Workshop A02 session.
#
# Uses the admin PAT (from the 'github-pats' K8s secret) to create a fresh
# repository in the chainloop-educates org, then pushes the bundled A01-end-state
# source from workshop/demo-app/ (which already has Chainloop attestation steps).
#
# Since only one session runs at a time (PoC constraint), the repo name is
# fixed as 'chainloop-demo'. The script deletes any existing repo first to
# ensure a clean starting state.
#
# PAT requirements:
#   admin-pat: repo + delete_repo scopes on the chainloop-educates org
#   user-pat:  repo scope (used by learners to clone and push)
set -euo pipefail

DEMO_APP_SOURCE="/home/eduk8s/workshop/demo-app"
GITHUB_ORG="chainloop-educates"
GITHUB_REPO_NAME="chainloop-demo"

# ── Read GitHub PATs from the Kubernetes secret ──────────────────────────────
GITHUB_ADMIN_PAT=$(kubectl get secret github-pats \
  -o jsonpath='{.data.admin-pat}' 2>/dev/null | base64 -d)

if [ -z "$GITHUB_ADMIN_PAT" ]; then
  echo "ERROR: Could not read GitHub admin PAT from secret 'github-pats'." >&2
  exit 1
fi

GITHUB_USER_PAT=$(kubectl get secret github-pats \
  -o jsonpath='{.data.user-pat}' 2>/dev/null | base64 -d)

# ── Create a fresh repository ─────────────────────────────────────────────────
echo "Preparing GitHub repository ${GITHUB_ORG}/${GITHUB_REPO_NAME}..."

export GH_TOKEN="${GITHUB_ADMIN_PAT}"

gh repo delete "${GITHUB_ORG}/${GITHUB_REPO_NAME}" --yes 2>/dev/null \
  && echo "Deleted existing repo." || echo "No existing repo to delete."

gh repo create "${GITHUB_ORG}/${GITHUB_REPO_NAME}" \
  --private \
  --description "Chainloop workshop demo app"

echo "Repository created: https://github.com/${GITHUB_ORG}/${GITHUB_REPO_NAME}"

# ── Push bundled A01-end-state source ─────────────────────────────────────────
echo "Populating repository from bundled A01-end-state source..."
WORK_DIR=$(mktemp -d)
cp -r "${DEMO_APP_SOURCE}/." "${WORK_DIR}/"

cd "${WORK_DIR}"
git init -b main
git config user.email "setup@educates.dev"
git config user.name "Workshop Setup"
git add -A
git commit -m "Initial commit: Chainloop demo app (A01 end-state / A02 starting state)"
git remote add origin "https://oauth2:${GITHUB_ADMIN_PAT}@github.com/${GITHUB_ORG}/${GITHUB_REPO_NAME}.git"
git push -u origin main
cd /
rm -rf "${WORK_DIR}"
echo "Repository populated successfully."

# ── Export environment variables ──────────────────────────────────────────────
GITHUB_REPO_URL="https://github.com/${GITHUB_ORG}/${GITHUB_REPO_NAME}"
GITHUB_REPO_URL_GIT="https://github.com/${GITHUB_ORG}/${GITHUB_REPO_NAME}.git"

cat > /etc/profile.d/github-env.sh <<EOF
export GH_TOKEN="${GITHUB_USER_PAT}"
export GITHUB_TOKEN="${GITHUB_USER_PAT}"
export GITHUB_ORG="${GITHUB_ORG}"
export GITHUB_REPO_NAME="${GITHUB_REPO_NAME}"
export GITHUB_REPO_URL="${GITHUB_REPO_URL}"
export GITHUB_REPO_URL_GIT="${GITHUB_REPO_URL_GIT}"
EOF

echo "GitHub environment configured:"
echo "  GITHUB_REPO_URL=${GITHUB_REPO_URL}"
