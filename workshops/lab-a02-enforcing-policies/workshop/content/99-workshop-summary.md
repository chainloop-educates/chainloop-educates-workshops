---
title: Summary and Next Steps
---

You have completed Workshop A02. Here is what you built and what it means.

## What Was Achieved

You started with a pipeline that produced attestations but imposed no quality requirements on them. You added a governance layer in three steps:

1. **Defined a policy** — a Rego file that checks whether a CycloneDX SBOM is present in every attestation
2. **Attached the policy to the contract** — initially in warn mode, so violations were recorded without blocking the pipeline
3. **Fixed the pipeline** — added SBOM generation with Syft, collected the SBOM as a material, switched the policy to block mode, and confirmed that the attestation is now fully compliant

The earlier violation is permanently recorded in the audit trail. It does not disappear. This is intentional: an immutable history of what was accepted, what was violated, and when each issue was resolved is exactly what compliance frameworks require.

## The Governance Model

Chainloop uses two layers of governance that work together:

- **Workflow contracts** define *what* evidence is required: which material types, mandatory or optional
- **Policies** define *how good* that evidence must be: programmable validation in Rego, with configurable enforcement modes

Together they give you both structural completeness (the contract) and quality assurance (the policies), enforced automatically on every pipeline run.

## What You Can Do Now

- Define policies for your own organisation's requirements
- Roll them out in `block: false` warn mode first — observe, then enforce
- Point auditors at the Chainloop UI: the evidence is there, signed, and permanent
- Use the audit trail to demonstrate compliance with SOC 2, SLSA, and internal governance policies

## Future Workshops in This Course

- **A03: Collecting Richer Evidence** — SARIF output from SAST scanners, container image signing with Cosign
- **A04: Multi-Team Governance** — shared policy libraries, role separation, organisation-level policy management
- **A05: SLSA Compliance** — mapping Chainloop evidence to SLSA Build Levels and generating a provenance statement

## Further Reading

- Chainloop documentation: [https://docs.chainloop.dev](https://docs.chainloop.dev)
- Chainloop GitHub repository: [https://github.com/chainloop-dev/chainloop](https://github.com/chainloop-dev/chainloop)
- Open Policy Agent (OPA) Rego reference: [https://www.openpolicyagent.org/docs/latest/policy-language/](https://www.openpolicyagent.org/docs/latest/policy-language/)
