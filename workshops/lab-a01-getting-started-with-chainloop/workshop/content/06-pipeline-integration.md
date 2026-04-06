---
title: Integrating Chainloop into Your Pipeline
---

The manual attestation showed you exactly what happens under the hood. Now automate it — add Chainloop attestation steps to the pre-populated GitHub Actions workflow so that every push automatically produces a signed attestation. You will add three jobs that mirror the three phases you ran manually: `attestation-init`, `build-push`, and `attestation-push`.

## Part 1 — Clone the Repository and Explore the Existing Workflow

Clone the pre-populated GitHub repository into your exercises directory:

```terminal:execute
command: git clone "$GITHUB_REPO_URL_GIT" ~/exercises/chainloop-demo
```

Move into the repository:

```terminal:execute
command: cd ~/exercises/chainloop-demo
```

Open the existing workflow file to see what the pipeline already does:

```editor:open-file
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
```

The workflow currently has a single job — `build-push` — that builds a container image and pushes it to the GitHub Container Registry (`ghcr.io`). There are no Chainloop steps yet — that is what you add in Parts 2 and 3.

## Part 2 — Add the Chainloop Secrets to the Repository

The pipeline needs two repository secrets to work with Chainloop:

- **`CHAINLOOP_TOKEN`** — authenticates the Chainloop CLI in pipeline jobs (the same token that is in your terminal session)
- **`CHAINLOOP_WORKFLOW`** — the workflow name to attest against (your session-unique workflow name)

Your terminal session is already authenticated to GitHub via `$GH_TOKEN`. Set both secrets with the `gh` CLI:

```terminal:execute
command: |-
  gh secret set CHAINLOOP_TOKEN \
    --body "$CHAINLOOP_TOKEN" \
    --repo "chainloop-educates/chainloop-demo"
```

```terminal:execute
command: |-
  gh secret set CHAINLOOP_WORKFLOW \
    --body "$SESSION_NAMESPACE-demo" \
    --repo "chainloop-educates/chainloop-demo"
```

Confirm both secrets are listed on the repository:

```terminal:execute
command: gh secret list --repo "chainloop-educates/chainloop-demo"
```

You should see `CHAINLOOP_TOKEN` and `CHAINLOOP_WORKFLOW` in the output. The values are masked — GitHub never displays them after they are stored.

{{< note >}}
Repository secrets in GitHub Actions are encrypted at rest. They are exposed to workflow runs only as environment variables and are never written to logs, even if a script step accidentally echoes them.
{{< /note >}}

## Part 3 — Add Chainloop Attestation Jobs to the Workflow

The updated workflow needs three jobs. Replace the entire contents of `build.yml` with the version below, which adds the Chainloop attestation jobs while keeping the existing build job intact:

```editor:create-file
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
text: |2
  name: Build and Attest

  on:
    push:
      branches: [main]

  env:
    IMAGE_TAG: ghcr.io/${{ github.repository }}:${{ github.sha }}
    IMAGE_LATEST: ghcr.io/${{ github.repository }}:latest

  jobs:
    # Chainloop attestation: init
    attestation-init:
      runs-on: ubuntu-latest
      outputs:
        attestation-id: ${{ steps.init.outputs.attestation-id }}
      steps:
        - name: Install Chainloop CLI
          run: curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin
        - name: Initialize attestation
          id: init
          env:
            CHAINLOOP_TOKEN: ${{ secrets.CHAINLOOP_TOKEN }}
          run: |
            ATTESTATION_ID=$(chainloop attestation init \
              --workflow "${{ secrets.CHAINLOOP_WORKFLOW }}" \
              --remote-state \
              -o json | jq -r '.id')
            echo "attestation-id=$ATTESTATION_ID" >> "$GITHUB_OUTPUT"

    # Build and push container image
    build-push:
      runs-on: ubuntu-latest
      needs: attestation-init
      permissions:
        contents: read
        packages: write
      steps:
        - uses: actions/checkout@v4
        - name: Log in to GitHub Container Registry
          uses: docker/login-action@v3
          with:
            registry: ghcr.io
            username: ${{ github.actor }}
            password: ${{ secrets.GITHUB_TOKEN }}
        - name: Build and push image
          uses: docker/build-push-action@v5
          with:
            push: true
            tags: |
              ${{ env.IMAGE_TAG }}
              ${{ env.IMAGE_LATEST }}

    # Chainloop attestation: add evidence and push
    attestation-push:
      runs-on: ubuntu-latest
      needs: [attestation-init, build-push]
      steps:
        - name: Install Chainloop CLI
          run: curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin
        - name: Add container image evidence
          env:
            CHAINLOOP_TOKEN: ${{ secrets.CHAINLOOP_TOKEN }}
          run: |
            chainloop attestation add \
              --name container-image \
              --value "ghcr.io/${{ github.repository }}:${{ github.sha }}" \
              --attestation-id "${{ needs.attestation-init.outputs.attestation-id }}"
        - name: Push attestation
          env:
            CHAINLOOP_TOKEN: ${{ secrets.CHAINLOOP_TOKEN }}
          run: |
            chainloop attestation push \
              --attestation-id "${{ needs.attestation-init.outputs.attestation-id }}"
```

### How the Three Jobs Work Together

- **`attestation-init`** runs first, before any build work. It starts the attestation server-side (via `--remote-state`) and writes the attestation ID to `$GITHUB_OUTPUT`, making it available to downstream jobs as a job output.
- **`build-push`** runs after `attestation-init` (via `needs:`). It builds the container image and pushes it to `ghcr.io`. Docker is already available on `ubuntu-latest` runners — no `docker:dind` service needed.
- **`attestation-push`** runs after both previous jobs complete. It adds the built image as evidence (using the attestation ID from job outputs), then signs and submits the completed attestation.

The job output mechanism (`$GITHUB_OUTPUT`) is how GitHub Actions passes values between jobs — it replaces the dotenv artifact pattern used in other CI systems.

{{< note >}}
Each job installs the Chainloop CLI at runtime using the official install script. In a production pipeline you would use a custom runner image with the Chainloop CLI pre-installed, eliminating the install step from every job.
{{< /note >}}

## Part 4 — Commit, Push, and Watch

Commit the updated workflow file and push it to GitHub to trigger a run:

```terminal:execute
command: |-
  cd ~/exercises/chainloop-demo && \
  git add .github/workflows/build.yml && \
  git commit -m "Add Chainloop attestation to pipeline" && \
  git push
```

Switch to GitHub to watch the workflow execute:

```dashboard:open-url
url: https://github.com/chainloop-educates/chainloop-demo/actions
```

You should see the `Build and Attest` workflow appear. Once it starts, click into it to see the three jobs running in sequence — `attestation-init`, then `build-push`, then `attestation-push`.

Once the workflow completes successfully, switch to Chainloop to see the new attestation:

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

Your GitHub Actions workflow now automatically produces a signed, tamper-proof attestation on every push. The three-job pattern — init before the build, add evidence after the build, push in a final job — can be extended with additional `attestation add` steps for each new material type you add to the contract.

Head to the summary page to review what you built and preview what comes next.
