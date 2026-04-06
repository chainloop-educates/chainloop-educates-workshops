---
title: "Chainloop: Workflows, Contracts, and Attestations"
---

Before writing any commands, it helps to have precise names for the four things Chainloop manages. The view-only Chainloop instance you opened on the previous page is the best reference — keep it open and refer back to it as you read through each concept below.

## Workflow

A **Workflow** is a named pipeline activity that Chainloop governs. It is the anchor point for everything else: contracts are linked to workflows, and attestations are produced against workflow runs.

Every CI job that produces evidence is associated with a workflow. The workflow name is what you pass to `chainloop attestation init` at the start of a pipeline run. In the view-only instance, click on **Workflows** in the left navigation to see a list of governed pipeline activities.

Workflows are also the unit of visibility: the Chainloop UI shows run history, pass/fail status, and evidence completeness at the workflow level.

## Workflow Contract

A **Workflow Contract** is a declarative YAML document that specifies what evidence a workflow must collect. Think of it as a checklist that every pipeline run must satisfy.

Contracts define:

- **Material requirements** — which types of artefacts must be present (container images, SBOMs, SARIF reports, etc.)
- **Policies** — Rego rules that validate whether the collected evidence meets your standards (covered in Workshop A02)

In the view-only instance, navigate to a workflow and find its linked contract. Notice the `materials` section listing the required evidence types.

Contracts are versioned. When you update a contract, existing attestations retain a reference to the contract version they were validated against. This means policy changes do not retroactively alter the historical record.

## Attestation

An **Attestation** is a signed, tamper-proof record created during a pipeline run. It links evidence to a specific execution context — the commit SHA, the runner, the timestamp, the workflow — and is cryptographically signed using Sigstore's keyless signing flow.

Attestations are based on the **in-toto specification**, an open standard for supply chain metadata. This means they are interoperable with other in-toto-aware tools and can be independently verified without Chainloop.

In the view-only instance, open a recent workflow run and look at the attestation detail. Notice the signature section and the raw in-toto envelope — this is the object that makes the evidence tamper-proof.

## Material / Evidence

**Materials** (also called evidence) are the actual artefacts attached to an attestation: container image references (including their immutable digest), SBOMs in CycloneDX or SPDX format, SARIF vulnerability scan results, JUnit test reports, and more.

Chainloop knows the semantics of each material type. For container images, it records both the tag and the digest — so even if the tag is later overwritten, the attestation retains a permanent reference to the exact image layer that was built.

In the view-only instance, open an attestation and scroll to the **Materials** section to see the artefacts collected during that run.

## How the Pieces Fit Together

The relationship between the four concepts follows a simple flow:

```
Contract → Workflow → (pipeline run) → Attestation + Materials
```

A contract defines the rules. A workflow is governed by a contract. Each pipeline run produces an attestation against that workflow. The attestation contains materials that satisfy (or fail to satisfy) the contract's requirements.

## Role Separation

One of Chainloop's core design principles is the separation between the people who *define* evidence requirements and the people who *produce* evidence:

- **Security teams** own contracts — they decide what evidence must be collected and what policies must pass
- **Developers** own pipelines — they add the Chainloop attestation steps that collect the evidence

Developers do not need to understand the policy details. Security teams do not need to modify CI pipelines. The contract is the interface between the two.

## Refer Back to the View-Only Instance

If you closed the Chainloop browser tab, open it again now:

```dashboard:open-url
url: https://app.chainloop.dev/u/chainloop
```

Spend a moment mapping what you see in the UI to the four concepts above. On the next page, you will verify your CLI setup and connect to the workshop Chainloop instance where you will build your own versions of these objects.
