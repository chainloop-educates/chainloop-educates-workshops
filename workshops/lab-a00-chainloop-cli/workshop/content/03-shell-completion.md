---
title: Set Up Shell Completion
---

The Chainloop CLI can generate shell completion scripts for `bash`, `zsh`, `fish`, and `PowerShell`. Enabling completion lets you press `Tab` to auto-complete commands, sub-commands, and flag names.

## Generate the Completion Script

See what the bash completion script looks like:

```terminal:execute
command: chainloop completion bash | head -20
```

## Install Completion for This Session

Source the completion script directly into your current shell session so completion is active immediately:

```terminal:execute
command: source <(chainloop completion bash)
```

Test it by typing `chainloop ` and pressing `Tab` — you should see the available sub-commands listed.

## Make Completion Persistent

To enable completion automatically in every future shell session, add the source line to `~/.bashrc`:

```terminal:execute
command: |-
  echo 'source <(chainloop completion bash)' >> ~/.bashrc
  echo "Completion added to ~/.bashrc"
```

The next time a bash session starts, completion will be active without any manual step.

{{< note >}}
If you prefer `zsh`, replace `bash` with `zsh` in both commands above and add the result to your `~/.zshrc` instead.
{{< /note >}}
