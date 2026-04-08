---
title: Integrating Chainloop into Your Pipeline
---

The manual attestation showed you exactly what happens under the hood. Now automate it — add Chainloop attestation stages to the pre-populated GitLab CI pipeline so that every push automatically produces a signed attestation. You will add three jobs that mirror the three phases you ran manually: `attestation-init`, `build-push`, and `attestation-push`.

## Part 1 — Clone the Repository and Explore the Existing Pipeline

Clone the pre-populated GitLab repository into your exercises directory:

```terminal:execute
command: git clone "https://$GITLAB_USER:$GITLAB_PASSWORD@${GITLAB_REPO_URL_GIT#https://}" ~/exercises/chainloop-demo
```

Move into the repository:

```terminal:execute
command: cd ~/exercises/chainloop-demo
```

Open the existing pipeline file to see what it already does:

```editor:open-file
file: ~/exercises/chainloop-demo/.gitlab-ci.yml
```

The pipeline currently has a single job — `build-push` — that builds a container image and pushes it to the GitLab Container Registry. There are no Chainloop steps yet — that is what you add in Parts 2 and 3.

## Part 2 — Add the Chainloop Variables to the Pipeline

The pipeline needs two CI/CD variables to work with Chainloop:

- **`CHAINLOOP_TOKEN`** — authenticates the Chainloop CLI in pipeline jobs (the same token that is in your terminal session)
- **`CHAINLOOP_WORKFLOW`** — the workflow name to attest against (your session-unique workflow name)

Open the CI/CD settings page for your repository:

```dashboard:open-url
url: https://gitlab-gitlab.{{< param ingress_domain >}}/{{< param session_name >}}/chainloop-demo/-/settings/ci_cd
```

Scroll down to the **Variables** section and expand it. Add two variables:

1. Click **Add variable**, set **Key** to `CHAINLOOP_TOKEN`, paste the value from your terminal (see below), check **Mask variable**, then click **Add variable**.
2. Repeat for **Key** `CHAINLOOP_WORKFLOW` with the value shown below.

Get both values from your terminal:

```terminal:execute
command: |-
  echo "CHAINLOOP_TOKEN  : $CHAINLOOP_TOKEN"
  echo "CHAINLOOP_WORKFLOW: $SESSION_NAMESPACE-demo"
```

Once saved, both variables will appear in the Variables list. Masked variables are never written to pipeline logs, even if a script step accidentally echoes them.

{{< note >}}
GitLab CI/CD variables set at the project level are available to all pipeline jobs as environment variables. You control visibility with the **Mask** and **Protect** flags — masked values are redacted in logs; protected variables are only available on protected branches.
{{< /note >}}

## Part 3 — Add Chainloop Attestation Jobs to the Pipeline

The updated pipeline needs three stages and three jobs. Replace the entire contents of `.gitlab-ci.yml` with the version below, which adds the Chainloop attestation jobs while keeping the existing build job intact:

```editor:create-file
file: ~/exercises/chainloop-demo/.gitlab-ci.yml
text: |2
  # Build and Attest — Chainloop-integrated GitLab CI pipeline

  stages:
    - attest-init
    - build
    - attest-push

  variables:
    IMAGE_TAG: "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
    IMAGE_LATEST: "$CI_REGISTRY_IMAGE:latest"

  # Chainloop attestation: init
  attestation-init:
    stage: attest-init
    image: alpine:3
    before_script:
      - apk add --no-cache curl jq
      - curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin
    script:
      - |
        ATTESTATION_ID=$(chainloop attestation init \
          --workflow "$CHAINLOOP_WORKFLOW" \
          --remote-state \
          -o json | jq -r '.id')
        echo "ATTESTATION_ID=$ATTESTATION_ID" >> attestation.env
    artifacts:
      reports:
        dotenv: attestation.env

  # Build and push container image
  build-push:
    stage: build
    image: docker:24
    services:
      - docker:24-dind
    variables:
      DOCKER_HOST: tcp://docker:2376
      DOCKER_TLS_CERTDIR: "/certs"
    needs:
      - job: attestation-init
        artifacts: true
    before_script:
      - docker login -u "$CI_REGISTRY_USER" -p "$CI_JOB_TOKEN" "$CI_REGISTRY"
    script:
      - docker build -t "$IMAGE_TAG" -t "$IMAGE_LATEST" .
      - docker push "$IMAGE_TAG"
      - docker push "$IMAGE_LATEST"

  # Chainloop attestation: add evidence and push
  attestation-push:
    stage: attest-push
    image: alpine:3
    needs:
      - job: attestation-init
        artifacts: true
      - job: build-push
    before_script:
      - apk add --no-cache curl jq
      - curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin
    script:
      - |
        chainloop attestation add \
          --name container-image \
          --value "$IMAGE_TAG" \
          --attestation-id "$ATTESTATION_ID"
      - |
        chainloop attestation push \
          --attestation-id "$ATTESTATION_ID"
```

### How the Three Jobs Work Together

- **`attestation-init`** runs first, before any build work. It starts the attestation server-side (via `--remote-state`) and writes the attestation ID to `attestation.env`. GitLab's `artifacts:reports:dotenv` mechanism makes this file available as environment variables to downstream jobs.
- **`build-push`** runs after `attestation-init` (via `needs:`). It builds the container image and pushes it to the GitLab Container Registry using the built-in `$CI_REGISTRY_USER`, `$CI_JOB_TOKEN`, and `$CI_REGISTRY` variables — no manual credentials needed.
- **`attestation-push`** runs after both previous jobs complete. It adds the built image as evidence (using the attestation ID from the dotenv artifact), then signs and submits the completed attestation.

The `artifacts:reports:dotenv` mechanism is how GitLab CI passes values between jobs — it exports variables from a file in one job and injects them as environment variables into downstream jobs that declare `artifacts: true` in their `needs:` entry.

{{< note >}}
Each job installs the Chainloop CLI at runtime using the official install script. In a production pipeline you would use a custom runner image with the Chainloop CLI pre-installed, eliminating the install step from every job.
{{< /note >}}

## Part 4 — Commit, Push, and Watch

Commit the updated pipeline file and push it to GitLab to trigger a run:

```terminal:execute
command: |-
  cd ~/exercises/chainloop-demo && \
  git add .gitlab-ci.yml && \
  git commit -m "Add Chainloop attestation to pipeline" && \
  git push "https://$GITLAB_USER:$GITLAB_PASSWORD@${GITLAB_REPO_URL_GIT#https://}" HEAD:main
```

Switch to GitLab to watch the pipeline execute:

```dashboard:open-url
url: https://gitlab-gitlab.{{< param ingress_domain >}}/{{< param session_name >}}/chainloop-demo/-/pipelines
```

You should see a new pipeline appear. Once it starts, click into it to see the three jobs running in sequence — `attestation-init`, then `build-push`, then `attestation-push`.

Once the pipeline completes successfully, switch to Chainloop to see the new attestation:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

Your workflow should now show two attestation entries: the manual one you created in the previous section, and the new pipeline-generated one. Click into the pipeline attestation to verify:

- The **container image** material is present with the correct commit SHA tag
- The image digest (not just the tag) is recorded — this is the immutable reference
- The attestation status is **success**

{{< note >}}
Chainloop records the container image digest, not just the tag. Tags are mutable — a tag like `main-abc1234` can be overwritten. The digest is immutable and permanently identifies the exact set of layers that was built. Future audits can verify the image in production against this digest.
{{< /note >}}

## What You Have Achieved

Your GitLab CI pipeline now automatically produces a signed, tamper-proof attestation on every push. The three-job pattern — init before the build, add evidence after the build, push in a final job — can be extended with additional `attestation add` steps for each new material type you add to the contract.

Head to the summary page to review what you built and preview what comes next.
