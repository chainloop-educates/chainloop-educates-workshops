---
title: Updating the Workflow Contract
---

The workflow contract from Workshop A01 only required a container image. This page updates the contract to also require a CycloneDX SBOM and to reference the new Rego policy.

## Check the Current Contract

First, see what the current contract looks like:

```terminal:execute
command: |-
  chainloop workflow contract describe \
    --name "$SESSION_NAMESPACE-contract"
```

You should see a single material requirement: `CONTAINER_IMAGE`. There is no SBOM requirement and no policy reference yet.

## Read the Updated Contract

Open the pre-prepared contract file:

```editor:open-file
file: ~/exercises/chainloop/workflow-contract-v2.yaml
```

## What Changed

Compared to the Workshop A01 contract, two things are new:

**A new material: `SBOM_CYCLONEDX_JSON`**

```yaml
- type: SBOM_CYCLONEDX_JSON
  name: sbom
  optional: false
```

The pipeline must now collect a CycloneDX SBOM and attach it to the attestation as a material named `sbom`. Setting `optional: false` makes this a hard contract requirement — but the policy we are adding provides an additional, programmable layer of validation on top.

**A policy reference**

```yaml
policies:
  - ref: file://chainloop/sbom-policy.rego
    type: ATTESTATION
    enforcement:
      block: false
```

The policy is referenced by file path relative to the contract. `type: ATTESTATION` means this is an attestation-level policy (evaluated against the whole attestation, not a single material). `block: false` puts the policy in warn mode — violations are recorded but the attestation push succeeds. You will switch this to `block: true` in a later step.

## Upload the New Contract Version

Push the updated contract to Chainloop:

```terminal:execute
command: |-
  chainloop workflow contract update \
    --name "$SESSION_NAMESPACE-contract" \
    --schema ~/exercises/chainloop/workflow-contract-v2.yaml
```

## Verify the New Version

Check that the contract now has a new version:

```terminal:execute
command: |-
  chainloop workflow contract describe \
    --name "$SESSION_NAMESPACE-contract"
```

You should see version 2 of the contract, including the `SBOM_CYCLONEDX_JSON` material and the policy reference.

## Confirm in the Browser

Open the Chainloop Educates instance and navigate to your workflow contract to confirm the update:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

{{< note >}}
Contract versioning is automatic. Every call to `contract update` creates a new immutable version while preserving the full history. Workflows remain linked to their contract by name and always use the latest version.
{{< /note >}}
