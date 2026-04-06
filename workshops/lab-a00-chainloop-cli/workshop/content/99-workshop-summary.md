---
title: Summary
---

You have successfully installed and configured the Chainloop CLI to communicate with the Chainloop control plane running in this cluster.

## What You Accomplished

- **Installed the Chainloop CLI** using the official install script into `~/.local/bin`
- **Configured server endpoints** with `chainloop config save`, pointing the CLI at the in-cluster control plane and CAS
- **Set your API token** by reading it from a pre-provisioned Kubernetes secret and exporting it as `CHAINLOOP_TOKEN`
- **Enabled shell completion** so tab-completion works for all Chainloop commands
- **Verified connectivity** by querying the control plane with `chainloop organization describe`

## Key Commands Reference

| Task | Command |
|------|---------|
| Configure server | `chainloop config save --control-plane <host>:443 --artifact-cas <host>:443` |
| View active config | `chainloop config view` |
| Check organisation | `chainloop organization describe` |
| List workflows | `chainloop workflow list` |
| Generate completion | `chainloop completion bash` |

## Next Steps

With the CLI in place and connectivity confirmed, you are ready to move on to the hands-on workshops:

- **lab-a01 — Getting Started with Chainloop**: Create your first workflow, write a contract, and run a manual attestation
- **lab-a02 — Enforcing Policies**: Add Rego policies to your contract and see how they gate attestations
