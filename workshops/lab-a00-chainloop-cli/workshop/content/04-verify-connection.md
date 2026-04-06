---
title: Verify Connection
---

With the server endpoints configured and your API token in place, you can now make a real API call to confirm end-to-end connectivity.

## Check Your Organisation

The `chainloop organization describe` command queries the control plane and returns details about the organisation your token belongs to:

```terminal:execute
command: chainloop organization describe
```

A successful response shows your organisation name, ID, and creation date. If you see a connection error, double-check:

- The server endpoints in `~/.config/chainloop/config.toml` match those shown on the overview page
- The `CHAINLOOP_TOKEN` environment variable is set (run `echo $CHAINLOOP_TOKEN | wc -c` to confirm it is non-empty)

## List Workflows

Confirm you can read data from the control plane by listing any workflows defined in your organisation:

```terminal:execute
command: chainloop workflow list
```

The list may be empty if no workflows have been created yet — that is expected. What matters is that the command completes without an authentication or connectivity error.

## Inspect the CLI Configuration

View the full active configuration, including the resolved server endpoints:

```terminal:execute
command: chainloop config view
```

{{< note >}}
The CLI stores its configuration in `~/.config/chainloop/config.toml`. The `CHAINLOOP_TOKEN` environment variable is intentionally kept out of this file — tokens are always passed through the environment, never written to disk by the CLI.
{{< /note >}}

You are now ready to use the Chainloop CLI in your workflows. Proceed to the next workshop to create your first workflow and contract.
