---
title: Fixing the Pipeline
---

The policy violation tells you exactly what is missing: a CycloneDX SBOM. This page fixes the pipeline by adding SBOM generation with Syft, then switches the policy to block mode and confirms the attestation is now compliant.

## Part 1 — Add SBOM Generation to the Pipeline

Open the current GitHub Actions workflow file:

```editor:open-file
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
```

The workflow currently has three jobs: `attestation-init`, `build-push`, and `attestation-push`. You will add two things:

1. A new `generate-sbom` job that runs Syft after the image is built and uploads the SBOM as a workflow artifact
2. An updated `attestation-push` job that downloads the SBOM artifact and attaches it as a material before pushing the attestation

Replace the `attestation-push` job (and its comment) with the `generate-sbom` job followed by the updated `attestation-push`:

```editor:replace-matching-text
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
match: |2
  # ── Chainloop attestation: add evidence and push ──────────────────────────────
  attestation-push:
    runs-on: ubuntu-latest
    needs: [attestation-init, build-push]
replacement: |2
  # ── Generate CycloneDX SBOM ───────────────────────────────────────────────────
  generate-sbom:
    runs-on: ubuntu-latest
    needs: build-push
    steps:
      - name: Install Syft
        run: curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
      - name: Generate SBOM
        run: syft "ghcr.io/${{ github.repository }}:${{ github.sha }}" -o cyclonedx-json > sbom.cyclonedx.json
      - name: Upload SBOM artifact
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.cyclonedx.json

  # ── Chainloop attestation: add evidence and push ──────────────────────────────
  attestation-push:
    runs-on: ubuntu-latest
    needs: [attestation-init, build-push, generate-sbom]
```

Now update the steps inside `attestation-push` to download the SBOM artifact and add it as evidence before pushing:

```editor:replace-matching-text
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
match: |2
      - name: Install Chainloop CLI
        run: curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin

      - name: Add container image evidence
replacement: |2
      - name: Download SBOM artifact
        uses: actions/download-artifact@v4
        with:
          name: sbom

      - name: Install Chainloop CLI
        run: curl -sfL https://raw.githubusercontent.com/chainloop-dev/chainloop/main/extras/install.sh | sh -s -- --path /usr/local/bin

      - name: Add container image evidence
```

Finally, add the SBOM evidence step after the container image step:

```editor:replace-matching-text
file: ~/exercises/chainloop-demo/.github/workflows/build.yml
match: |2
      - name: Push attestation
replacement: |2
      - name: Add SBOM evidence
        env:
          CHAINLOOP_TOKEN: ${{ secrets.CHAINLOOP_TOKEN }}
        run: |
          chainloop attestation add \
            --name sbom \
            --value sbom.cyclonedx.json \
            --attestation-id "${{ needs.attestation-init.outputs.attestation-id }}"

      - name: Push attestation
```

{{< note >}}
Syft pulls the image from `ghcr.io` to scan it — the image must be publicly accessible or the runner must be authenticated. GitHub Actions runners can pull from `ghcr.io` within the same organisation using `GITHUB_TOKEN`. If the package is set to private, the runner needs explicit read access.
{{< /note >}}

## Part 2 — Switch the Policy to Block Mode

With the pipeline now generating an SBOM, it is safe to enforce the policy strictly. Update the contract to set `block: true`:

```editor:replace-matching-text
file: ~/exercises/chainloop/workflow-contract-v2.yaml
match: |-
  enforcement:
        block: false
replacement: |-
  enforcement:
        block: true
```

Upload the updated contract:

```terminal:execute
command: |-
  chainloop workflow contract update \
    --name "$SESSION_NAMESPACE-contract" \
    --schema ~/exercises/chainloop/workflow-contract-v2.yaml
```

## Part 3 — Commit, Push, and Confirm

Stage and commit both changes:

```terminal:execute
command: |-
  cd ~/exercises/chainloop-demo && \
  git add .github/workflows/build.yml && \
  git commit -m "Add SBOM generation with Syft; switch policy to block mode" && \
  git push
```

Watch the workflow run in GitHub Actions:

```dashboard:open-url
url: https://github.com/chainloop-educates/chainloop-demo/actions
```

This time the workflow should complete all four jobs including `generate-sbom`. The SBOM is generated, uploaded as an artifact, and then downloaded and attached to the attestation.

## Confirm Compliance in Chainloop

Switch to the Chainloop browser tab and open the latest attestation:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

The policy evaluation results should now show all policies **passing**. The attestation includes both the container image and the SBOM, and the policy is satisfied.
