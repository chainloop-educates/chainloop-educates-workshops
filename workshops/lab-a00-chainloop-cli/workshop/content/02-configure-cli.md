---
title: Configure the CLI
---

Once installed, the Chainloop CLI needs two pieces of configuration before it can talk to a server:

1. **Server endpoints** — where the control plane and artifact storage (CAS) are running
2. **API token** — your credential for authenticating requests

## Point the CLI at the In-Cluster Server

Your Chainloop instance is reachable at the following endpoints:

| Service | Address |
|---------|---------|
| Control Plane | `api-cp.{{< param ingress_domain >}}:443` |
| Artifact CAS | `api-cas.{{< param ingress_domain >}}:443` |

Run `chainloop config save` to write these into the CLI's configuration file:

```terminal:execute
command: |-
  chainloop config save \
    --control-plane api-cp.{{< param ingress_domain >}}:443 \
    --artifact-cas api-cas.{{< param ingress_domain >}}:443 \
    --insecure=false
```

The configuration is saved to `~/.config/chainloop/config.toml`. You can inspect it at any time:

```terminal:execute
command: cat ~/.config/chainloop/config.toml
```

Alternatively, you can use the Chainloop CLI's config command:

```terminal:execute
command: chainloop config view
```

## Retrieve Your API Token

Your API token has been pre-provisioned as a Kubernetes secret. Retrieve it and export it as the `CHAINLOOP_TOKEN` environment variable, which the CLI reads automatically:

```terminal:execute
command: |-
  export CHAINLOOP_TOKEN=$(kubectl get secret chainloop-admin-token \
    -o jsonpath='{.data.token}' | base64 -d)
  echo "Token configured (length: ${#CHAINLOOP_TOKEN} chars)"
```

{{< note >}}
The token is sensitive — avoid printing its full value to the terminal. The command above only confirms that it was retrieved successfully by showing its character count.
{{< /note >}}

To make the token available in future terminal sessions, append the export to `~/.bashrc`:

```terminal:execute
command: |-
  CHAINLOOP_TOKEN_VALUE=$(kubectl get secret chainloop-admin-token \
    -o jsonpath='{.data.token}' | base64 -d)
  echo "export CHAINLOOP_TOKEN=${CHAINLOOP_TOKEN_VALUE}" >> ~/.bashrc
  echo "export DO_NOT_TRACK=1" >> ~/.bashrc
```

{{< note >}}
`DO_NOT_TRACK=1` disables telemetry in the Chainloop CLI. It is a good practice to set this in workshop environments.
{{< /note >}}
