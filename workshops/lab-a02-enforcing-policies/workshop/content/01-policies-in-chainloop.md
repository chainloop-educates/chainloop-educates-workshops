---
title: Policies in Chainloop
---

Chainloop uses two complementary mechanisms to govern what ends up in an attestation. Understanding the distinction between them is essential before writing your first policy.

## Contracts vs. Policies

A **workflow contract** defines *what* evidence is required: which material types must be collected, whether they are mandatory or optional, and what their names should be. If a required material is missing, Chainloop rejects the attestation push entirely.

A **policy** defines *how good* that evidence must be. Policies can check whether a specific material type is present, inspect the *content* of a material (for example, flagging banned components in an SBOM or critical findings in a SARIF report), or validate metadata on the attestation envelope. Policies give you a richer, programmable governance layer on top of the structural contract.

## Rego — the Policy Language

Chainloop policies are written in **Rego** — the same policy language used by Open Policy Agent (OPA). Rego is purpose-built for expressing structured queries over JSON data, which makes it well-suited for examining attestation evidence. Chainloop passes the attestation as `input` and your policy returns a set of `violations`.

## Two Policy Types

| Type | Evaluated against | Typical use case |
|---|---|---|
| **Attestation policy** | The whole attestation | Check which material types are present, validate metadata, annotations |
| **Material policy** | A single material | Check SBOM content, SARIF findings, image digest format |

In this workshop you will write an **attestation policy** that checks whether a CycloneDX SBOM material is present.

## Enforcement Modes

Every policy reference in a contract has an enforcement mode:

- **`block: false`** (warn mode) — a violation is logged against the attestation but the push succeeds. The violation is visible in the UI and included in the audit trail. Use this when rolling out a new policy so you can observe its effect before it blocks pipelines.
- **`block: true`** — a violation causes the attestation push to fail. The pipeline job that calls `chainloop attestation push` exits with an error. Use this for hard requirements that must be met before an attestation is accepted.

The recommended rollout pattern is to start in warn mode, observe violations across real pipeline runs, fix the issues, and then switch to block mode once you are confident the pipeline is producing the required evidence.

## Seeing Policies in a Real Deployment

Open the view-only Chainloop instance in your browser to see how policies appear in a mature deployment:

```dashboard:open-url
url: https://app.chainloop.dev/u/chainloop
```

Navigate to the **Policies** section if available, or open an attestation detail to see its policy evaluation results. Notice that each attestation records which policies were evaluated, what the result was, and when the evaluation happened.
