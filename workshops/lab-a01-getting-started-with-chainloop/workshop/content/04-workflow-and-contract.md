---
title: Creating a Workflow and Contract
---

A workflow tells Chainloop "this is a pipeline activity I want to govern." A contract tells it "here is what evidence that activity must produce." You need both before you can create an attestation. Create them now, then link them together.

## Part 1 — Create a Workflow

A workflow is the named object that Chainloop uses to track a governed pipeline activity over time. Every attestation is produced against a workflow, and the workflow is where you see run history, compliance status, and evidence completeness in the UI.

Create a workflow for this session. The `--name` flag uses `$SESSION_NAMESPACE` to ensure the name is unique across concurrent workshop sessions:

```terminal:execute
command: |-
  chainloop workflow create \
    --name "$SESSION_NAMESPACE-demo" \
    --project "workshop"
```

Confirm the workflow was created successfully:

```terminal:execute
command: chainloop workflow list
```

You should see one row in the output — your new workflow, with no contract linked yet. Switch to the Chainloop browser tab and navigate to **Workflows** to see it in the UI as well:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

## Part 2 — Review the Starter Contract

A contract file is ready for you in the exercises directory. Open it now:

```editor:open-file
file: ~/exercises/chainloop/workflow-contract.yaml
```

Walk through the key fields:

- **`kind: CraftingSchema`** — this is the Chainloop resource type for a workflow contract
- **`materials`** — the list of evidence items that every workflow run must collect
- **`type: CONTAINER_IMAGE`** — a Chainloop material type; Chainloop understands how to validate container image references, including capturing the immutable digest alongside the tag

This contract is intentionally minimal: it says that every run of the linked workflow must collect exactly one piece of evidence — a container image reference. No policies, no additional material types. That comes in Workshop A02.

{{< note >}}
The `name` field inside each material entry (for example, `container-image`) is what you will reference when you run `chainloop attestation add --name container-image` later. It is the label that connects an attestation step in your pipeline to a specific material requirement in the contract.
{{< /note >}}

## Part 3 — Upload the Contract and Link It to the Workflow

<!-- Create the contract in Chainloop by uploading the local file. The `--name` flag again uses `$SESSION_NAMESPACE` to keep it unique:

```terminal:execute
command: |-
  chainloop workflow contract create \
    --name "$SESSION_NAMESPACE-contract" \
    -f ~/exercises/chainloop/workflow-contract.yaml
```

Now link the contract to the workflow you created in Part 1:

```terminal:execute
command: |-
  chainloop workflow update \
    --name "$SESSION_NAMESPACE-demo" \
    --contract "$SESSION_NAMESPACE-contract"
``` -->

Verify the link was established:

```terminal:execute
command: chainloop workflow list
```

The output should now show your workflow with the contract name listed alongside it. The two objects are connected.

Refresh the Chainloop browser tab. The workflow entry should now display the contract name, and clicking through to the workflow should show the contract details including the `CONTAINER_IMAGE` material requirement:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

## What You Have Now

You have a governed pipeline activity (`$SESSION_NAMESPACE-demo`) with a contract specifying that every run must produce a container image as evidence. The next step is to satisfy that contract by running an attestation — starting with a manual run so you can see exactly what happens at each stage.
