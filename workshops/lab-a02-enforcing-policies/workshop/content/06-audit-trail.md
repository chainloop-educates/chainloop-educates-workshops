---
title: Reviewing the Audit Trail
---

The pipeline is now policy-compliant. This page walks through what a compliance auditor or security reviewer would examine in the Chainloop dashboard — and maps each piece of evidence to a compliance framework.

## Open the Latest Compliant Attestation

Navigate to your workflow in the Chainloop browser tab and open the most recent attestation:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

## What an Auditor Examines

### 1. Attestation Envelope

The attestation is cryptographically signed using Sigstore's keyless signing model. The signature guarantees that the evidence was collected by a legitimate pipeline run and was not modified after collection. An auditor can verify the signature independently using `cosign` — Chainloop stores all the information needed to do so.

### 2. Materials Collected

Each material in the attestation is recorded with its value and a cryptographic digest:

- **Container image** — the image reference including the immutable SHA256 digest, not just a tag. This guarantees that the exact image in production is traceable back to this specific pipeline run.
- **CycloneDX SBOM** — the software bill of materials for that image, with its own digest. The SBOM is the foundation for software inventory requirements in frameworks like SOC 2 and FedRAMP.

### 3. Policy Evaluation Results

Every policy evaluated against the attestation is recorded with a timestamp:

- The earlier warn-mode violation (from the pipeline run before the SBOM was added) is still in the history. It does not disappear. The audit trail is append-only.
- The current compliant run shows all policies passing.

This history is important for auditors: it demonstrates that a violation was detected, recorded, and then resolved — exactly the kind of evidence a SOC 2 auditor looks for when assessing a change management process.

### 4. Workflow Metadata

The attestation records which Git commit triggered the run, the pipeline run ID, and the timestamp. This closes the loop between a deployed artifact and the exact code that produced it.

## Compliance Mapping

| Evidence collected | Compliance relevance |
|---|---|
| Signed attestation with commit SHA | SLSA Build L2: provenance |
| CycloneDX SBOM | SOC 2 / FedRAMP: software inventory |
| Policy evaluation pass/fail history | Internal governance audit trail |
| Immutable run history | SOC 2: change management |

## Seeing a Mature Audit Trail

Open the view-only instance in your browser to see what a multi-workflow, production-scale audit trail looks like:

```dashboard:open-url
url: https://app.chainloop.dev/u/chainloop
```

Notice the volume and variety of workflows, the consistency of evidence across runs, and the policy evaluation history. This is what Chainloop delivers automatically, for every pipeline run, without changing how your developers work. The audit trail is always complete, always tamper-proof, and always up to date.
