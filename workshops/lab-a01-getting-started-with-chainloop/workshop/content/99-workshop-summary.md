---
title: Summary and Next Steps
---

You have built a complete supply chain evidence pipeline from scratch. Every push to your GitLab repository now automatically produces a signed, tamper-proof attestation — a verifiable record of what was built, with a container image captured as evidence and stored in Chainloop where it cannot be altered.

## What You Built

Starting from a plain GitLab CI pipeline that builds and pushes a container image, you added:

- A **workflow contract** that declares a container image as required evidence for every pipeline run
- A **workflow** linked to that contract, giving Chainloop a governed view of this pipeline activity
- Three **attestation jobs** in the GitLab CI pipeline (init → add → push) that automate the attestation lifecycle on every commit
- A complete signed **attestation** with an immutable container image digest, queryable at any time from the Chainloop UI or CLI

## The Chainloop Model

The four concepts you worked with map to clear responsibilities in a real organisation:

| Concept | Who owns it | Purpose |
|---|---|---|
| Contract | Security team | Defines what evidence every run must produce |
| Workflow | Security team | Represents the governed pipeline activity |
| Attestation | Pipeline (automated) | The signed, tamper-proof record produced at runtime |
| Materials | Pipeline (automated) | The actual artefacts — images, SBOMs, scan results |

The contract is the interface between security requirements and pipeline implementation. Developers add attestation steps; security teams update contracts. Neither team needs to touch the other's domain.

## See a Production-Scale Example

Before moving to Workshop A02, take a final look at the view-only Chainloop instance. With the concepts and mechanics now in context, the production organisation should look familiar — workflows, contracts, run histories, materials:

```dashboard:open-url
url: https://app.chainloop.dev/u/chainloop
```

Notice how the workflow run list shows compliance status at a glance. That status is driven by the contract — runs that satisfy all material requirements are green; runs that are missing evidence are flagged. In your current workshop contract, the only requirement is a container image, so compliance is straightforward. Policies make this much more powerful.

## What Comes Next: Workshop A02

Your contract is intentionally minimal — it requires a container image and nothing else. Workshop A02 builds on this foundation:

- **Add an SBOM requirement** to the contract, so every pipeline run must also collect a Software Bill of Materials in CycloneDX format
- **Write a Rego policy** that validates the SBOM — for example, checking that it was generated with a specific tool or that no critical vulnerabilities are present
- **Attach the policy to the contract**, and watch Chainloop block a pipeline run that does not comply
- **Observe policy evaluation results** in the Chainloop UI, showing exactly which checks passed and which failed

The contract you created in this workshop is the starting point for Workshop A02. When you are ready, move on to `lab-a02-enforcing-policies`.
