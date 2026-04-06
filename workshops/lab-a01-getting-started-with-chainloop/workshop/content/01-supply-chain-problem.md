---
title: The Supply Chain Security Challenge
---

Your pipeline builds a container image, it passes tests, and it gets deployed to production. But consider what happens when an auditor asks: exactly what dependencies were present during that build? Did the vulnerability scanner run — and on which image digest? Was the image signed before it was pushed? Can you prove the image running in production is the same one the pipeline produced, and not something substituted afterward?

Most teams cannot answer these questions with confidence. Not because they are careless, but because the evidence was never collected in a verifiable way.

## The Evidence Gap

Every modern pipeline produces signals — test results, scan outputs, SBOMs, image digests — but those signals are scattered across disconnected systems:

- Test reports live in the CI runner's temporary workspace and are discarded after the job
- SBOMs may be generated but pushed to an object store with no link back to the pipeline run that produced them
- Vulnerability scan results appear in a dashboard that has no cryptographic connection to the specific build
- Image tags are mutable — the same tag can be overwritten silently

No single, verifiable record ties these artefacts together and proves they came from a specific, unmodified build. This is the **software supply chain evidence gap**.

## AI-Assisted Code Makes It Worse

When code is generated or modified with AI assistance, provenance questions become even more acute. Which model produced which change? Was the generated code reviewed before it entered the build? Organisations that cannot answer these questions today will face regulatory pressure to answer them tomorrow. Frameworks like SLSA, SSDF, and emerging AI bill-of-materials standards are moving from recommendations to requirements.

## Chainloop Closes the Gap

Chainloop was built to address exactly this problem. Rather than replacing your existing tools, it acts as the connective tissue — collecting tamper-proof attestations from your pipeline and enforcing policies about what that evidence must contain.

A Chainloop attestation is a **signed, in-toto envelope** produced during a pipeline run. It captures material evidence (images, SBOMs, scan results), records metadata about the run environment, and is cryptographically signed using Sigstore. Once pushed to Chainloop, the attestation cannot be altered. Auditors, security teams, and automated policy engines can query it at any time.

## See It in Action First

Before building anything, look at a real Chainloop organisation with live attestation data. Open the view-only Chainloop instance in your browser now:

```dashboard:open-url
url: https://app.chainloop.dev/u/chainloop
```

{{< note >}}
This is a real Chainloop organisation with production-scale data. Browse the workflow runs, open an attestation, and look at the materials collected — image digests, SBOMs, SARIF reports. This is the kind of audit trail you will build in this workshop.
{{< /note >}}

Take a few minutes to explore:

- Click into a **Workflow** to see its run history
- Open a recent **Attestation** and inspect the materials attached to it
- Notice the cryptographic signature and the in-toto envelope structure

When you are ready, move on to the next page where we name and define the Chainloop concepts you just saw.
