#!/bin/bash
# Set up GitLab environment variables for this workshop session.
# The GitLab instance and the learner's repository are already provisioned
# by the Educates GitLab operator — this script only exports the URLs and
# credentials the learner needs in their terminal.
set -euo pipefail

GITLAB_URL="https://gitlab-gitlab.${INGRESS_DOMAIN}"
GITLAB_USER="${SESSION_NAME}"
GITLAB_PASSWORD="Chainloop123"
GITLAB_REPO_URL="${GITLAB_URL}/${SESSION_NAME}/chainloop-demo"
GITLAB_REPO_URL_GIT="${GITLAB_URL}/${SESSION_NAME}/chainloop-demo.git"

cat >> "$HOME/.bashrc" <<EOF
export GITLAB_URL="${GITLAB_URL}"
export GITLAB_USER="${GITLAB_USER}"
export GITLAB_PASSWORD="${GITLAB_PASSWORD}"
export GITLAB_REPO_URL="${GITLAB_REPO_URL}"
export GITLAB_REPO_URL_GIT="${GITLAB_REPO_URL_GIT}"
EOF

echo "GitLab environment configured:"
echo "  GITLAB_URL=${GITLAB_URL}"
echo "  GITLAB_USER=${GITLAB_USER}"
echo "  GITLAB_REPO_URL=${GITLAB_REPO_URL}"
