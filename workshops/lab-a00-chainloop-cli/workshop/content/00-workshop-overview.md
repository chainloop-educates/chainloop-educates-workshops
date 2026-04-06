---
title: Workshop Overview
---

Chainloop is a supply chain security platform that lets you collect, sign, and verify attestations from your CI/CD pipelines. Every interaction with Chainloop — creating workflows, starting attestations, pushing evidence — goes through its command-line interface, the **Chainloop CLI**.

In this workshop you will set up the CLI from scratch, connect it to the Chainloop instance running in this cluster, and confirm that you can communicate with the control plane.

## What You Will Do

- Download and install the Chainloop CLI binary
- Configure the CLI to point at the in-cluster Chainloop control plane
- Retrieve your API token and set it as an environment variable
- Enable shell completion for faster command entry
- Verify end-to-end connectivity by querying the Chainloop server

## Your Chainloop Instance

A Chainloop control plane is already deployed in this cluster. Its API endpoints are based on the cluster ingress domain:

| Service | Endpoint |
|---------|----------|
| Control Plane (gRPC) | `api-cp.{{< param ingress_domain >}}:443` |
| Artifact CAS (gRPC) | `api-cas.{{< param ingress_domain >}}:443` |

You will use these addresses in the next section when you run `chainloop config save`.

{{< note >}}
Your API token has been pre-provisioned as a Kubernetes secret named `chainloop-admin-token` in your session namespace. You will retrieve it with `kubectl` during the configuration step.
{{< /note >}}

## Prerequisites

No prior Chainloop experience is required. Familiarity with a Linux terminal is assumed.
