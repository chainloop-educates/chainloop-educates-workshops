---
title: Install the Chainloop CLI
---

The Chainloop CLI is distributed as a single static binary for Linux and macOS. The official install script downloads the latest release and places it in a directory of your choice.

## Download and Install

Run the install script, directing it to place the binary in `~/.local/bin` — a directory that is already on your `PATH` in this workshop environment:

```terminal:execute
command: |-
  mkdir -p ~/.local/bin
  curl -sfL https://dl.chainloop.dev/cli/install.sh | bash -s -- --path ~/.local/bin
```

The script downloads the appropriate binary for your platform, verifies its checksum, and makes it executable.

## Verify the Installation

Confirm the binary is available and check the installed version:

```terminal:execute
command: chainloop version
```

You should see output showing the CLI version number. If the command is not found, ensure `~/.local/bin` is on your PATH:

```terminal:execute
command: echo $PATH
```

{{< note >}}
The workshop terminal already includes `~/.local/bin` in `PATH`, so no additional shell configuration is needed.
{{< /note >}}
