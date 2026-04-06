---
title: Workshop Overview
---

In Workshop A01, you connected your GitHub Actions workflow to Chainloop. It now produces a signed attestation on every run — but there are no rules about what that attestation must *contain*. Anyone could push an attestation with no meaningful evidence and it would be accepted. The pipeline is instrumented, but it is not yet governed.

This workshop adds the governance layer: **policies** that define what "good" evidence looks like. A policy can require that a specific type of evidence is present, that it meets certain content criteria, or both. You will write a policy, attach it to your workflow contract, observe a violation, fix the pipeline, and confirm compliance.

## Learning Objectives

After completing this workshop you will be able to:

- Explain what Rego policies are in the Chainloop context and how they differ from contract material requirements
- Write a policy that validates whether a specific material type is present in an attestation
- Attach a policy to a workflow contract and control its enforcement mode
- Trigger and read a policy violation in the Chainloop UI
- Extend a GitHub Actions pipeline to generate and collect a CycloneDX SBOM using Syft
- Explain how the Chainloop audit trail maps to compliance frameworks such as SOC 2 and SLSA

## What You Will Build

A policy-enforced pipeline where a missing CycloneDX SBOM causes a visible policy violation. You will first run the pipeline in warn mode so the violation is recorded but does not block the build. Then you will fix the pipeline to generate an SBOM, switch the policy to block mode, and confirm that the attestation is now fully compliant.

## Starting Point

The workflow, contract, and GitHub Actions integration from Workshop A01 are already set up in your session. The session setup reproduced the A01 end-state for you automatically — you can verify this now:

```terminal:execute
command: chainloop workflow list
```

You should see a workflow named `$SESSION_NAMESPACE-demo` with a linked contract. The GitHub repository also has the `CHAINLOOP_TOKEN` and `CHAINLOOP_WORKFLOW` secrets already set.

## Workshop Structure

The workshop moves through six stages:

1. **Policies in Chainloop** — understand the policy model, Rego, and enforcement modes
2. **Write a policy** — read the pre-prepared SBOM presence policy
3. **Update the contract** — attach the policy to your workflow contract
4. **Trigger a violation** — push a pipeline run that produces a violation in warn mode
5. **Fix the pipeline** — add SBOM generation with Syft and switch to block mode
6. **Audit trail** — review what a compliance auditor would examine

Let's get started.
