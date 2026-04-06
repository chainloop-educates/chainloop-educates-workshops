---
title: Your First Attestation
---

Before connecting the pipeline, run an attestation manually from the terminal. Understanding the three-phase lifecycle — **init → add → push** — makes the pipeline integration on the next page much easier to reason about, because the pipeline does exactly the same three steps, just in separate CI jobs.

## The Three Phases

Every Chainloop attestation goes through three phases:

- **init** — Start an attestation for a workflow run. Chainloop creates an in-progress record server-side and returns an attestation ID. All subsequent commands reference this ID.
- **add** — Collect and attach a piece of evidence (a material). You call `add` once for each material the contract requires. In this workshop the contract requires one container image, so you call `add` once.
- **push** — Sign and push the completed attestation to Chainloop. This is the point at which the cryptographic signature is applied using Sigstore's keyless signing. Once pushed, the attestation is immutable.

If a pipeline run fails between `init` and `push`, the in-progress attestation can be marked as failed or abandoned. Chainloop tracks run status over time, so an aborted attestation appears in the workflow history alongside successful ones.

## Step 1: Init

Start the attestation and capture the ID in an environment variable. The `--remote-state` flag tells Chainloop to store the attestation state server-side rather than in a local file — this is required for multi-job pipelines where different CI runners need to share state:

```terminal:execute
command: |-
  ATTESTATION_ID=$(chainloop attestation init \
    --workflow "$SESSION_NAMESPACE-demo" \
    --remote-state \
    -o json | jq -r '.id')
  echo "Attestation ID: $ATTESTATION_ID"
  echo "export ATTESTATION_ID=$ATTESTATION_ID" >> ~/.bashrc_attestation
```

You should see an attestation ID printed to the terminal — a UUID-style string. This ID is now stored in `~/.bashrc_attestation` so subsequent commands in this session can pick it up.

Switch to the Chainloop browser tab and navigate to your workflow. You should see an **in-progress** run appear — Chainloop has registered the attestation but it is not yet complete:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

## Step 2: Add Evidence

Add a container image reference as the required material. The `--name` flag must match the material name defined in the contract (`container-image`). Use a public nginx image for this manual demonstration:

```terminal:execute
command: |-
  source ~/.bashrc_attestation
  chainloop attestation add \
    --name container-image \
    --value "docker.io/library/nginx:latest" \
    --attestation-id "$ATTESTATION_ID"
```

Chainloop resolves the image reference and records the immutable digest alongside the tag. Even though you provided a mutable tag (`latest`), the attestation will contain the exact digest that tag resolved to at this moment.

## Step 3: Push

Sign and submit the completed attestation:

```terminal:execute
command: |-
  source ~/.bashrc_attestation
  chainloop attestation push \
    --attestation-id "$ATTESTATION_ID"
```

The `push` command signs the attestation envelope using Sigstore's keyless signing flow and then uploads it to Chainloop. You should see a success message with a reference to the submitted attestation.

## View the Result

Switch to the Chainloop browser tab and navigate to your workflow's run history. The attestation you just pushed should appear with status **success** and the container image evidence attached:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

Click into the attestation to explore:

- The **Materials** section shows the `container-image` entry with both the tag you provided and the digest Chainloop resolved
- The **Signature** section shows the Sigstore-based cryptographic signature
- The **Raw envelope** view shows the in-toto JSON structure underlying the attestation

{{< note >}}
The attestation is cryptographically signed using Sigstore's keyless signing flow. The signature proves that the evidence was not tampered with after it was collected, and it binds the attestation to the identity of the signer (in a pipeline context, the CI job's OIDC token). Click into the attestation to see the raw in-toto envelope.
{{< /note >}}

## What You Have Demonstrated

You have just run the complete Chainloop attestation lifecycle manually:

1. `init` — registered a workflow run with Chainloop
2. `add` — attached a container image as evidence
3. `push` — signed and submitted the tamper-proof record

The next page shows you how to embed these exact same three steps into your GitHub Actions workflow so they run automatically on every push.
