---
title: Workshop Overview
---

Modern CI pipelines build software reliably — but they leave almost no verifiable record of *how* that software was built. Which tools ran? Did the vulnerability scanner actually execute? Is the container image in production the one the pipeline produced? Chainloop is the connective tissue that fills this gap: it turns your pipeline into a tamper-proof evidence producer, collecting signed attestations that answer these questions for auditors, security teams, and your future self.

## What You Will Build

By the end of this workshop, your GitLab CI pipeline will automatically produce a **signed attestation** on every run. The attestation captures a container image reference as material evidence and pushes it to Chainloop, where it is stored, queryable, and verifiable. You will have gone from zero to a working supply chain security foundation in a single session.

## Learning Objectives

After completing this workshop you will be able to:

- Explain the Chainloop model: workflows, contracts, attestations, and material evidence
- Authenticate the Chainloop CLI against a hosted Chainloop instance
- Create a workflow and a workflow contract that specifies required evidence
- Run an attestation manually via the CLI using the init → add → push lifecycle
- Integrate Chainloop attestation steps into an existing GitLab CI pipeline
- Observe collected evidence and attestation details in the Chainloop UI

## Two Chainloop Instances

This workshop uses two separate Chainloop instances, each with a different purpose:

- **Chainloop Educates** (`app.chainloop.dev/u/educates`) — the hands-on workshop instance. Your session has a pre-provisioned API token scoped to this organisation. Everything you create (workflows, contracts, attestations) lives here.
- **Chainloop** (`app.chainloop.dev/u/chainloop`) — a real, production-scale Chainloop organisation with live data. You have read-only access. Use it to see what a mature Chainloop deployment looks like before you build your own.

You will open both instances during the workshop. The view-only instance gives you a target to aim for; the Educates instance is where you do the work.

## Workshop Structure

The workshop moves through five stages:

1. **Concepts** — the Chainloop model and the supply chain security problem it solves
2. **CLI setup** — verify the pre-installed CLI and confirm your session token works
3. **Workflow and contract** — create the governance objects that define what evidence to collect
4. **Manual attestation** — run the init → add → push lifecycle by hand to understand it fully
5. **Pipeline integration** — automate attestation in your GitLab CI pipeline

Let's get started.
