---
title: Setting Up the Chainloop CLI
---

The Chainloop CLI is pre-installed in this workshop environment, and your session API token has already been provisioned and exported as `$CHAINLOOP_TOKEN`. There is nothing to install or configure manually — but you should verify both are working correctly before going further.

## Verify the CLI Is Available

Check the installed version:

```terminal:execute
command: chainloop version
```

You should see the Chainloop CLI version number and build information. If you see a `command not found` error, let your instructor know — the environment may need to be restarted.

## Verify Authentication

The `$CHAINLOOP_TOKEN` environment variable is already set in your terminal session. The CLI picks it up automatically — you do not need to run `chainloop auth login`. Confirm the CLI can reach the workshop Chainloop organisation by listing workflows:

```terminal:execute
command: chainloop workflow list
```

The output should be an empty list — no workflows exist yet in your session. An empty list is a success response. If you see an authentication error instead, the token may not have been provisioned correctly; raise this with your instructor.

{{< note >}}
Your `$CHAINLOOP_TOKEN` is scoped to the **Chainloop Educates** organisation. Everything you create in this workshop lives in an isolated namespace within that organisation. Other workshop participants have their own tokens and cannot see your resources.
{{< /note >}}

## Explore the Environment Variables

Several environment variables are pre-set in your terminal. Take a moment to confirm they are all present:

```terminal:execute
command: |-
  echo "Session namespace : $SESSION_NAMESPACE"
  echo "Chainloop token   : ${CHAINLOOP_TOKEN:0:8}... (truncated)"
  echo "GitLab URL        : $GITLAB_URL"
  echo "GitLab repo URL   : $GITLAB_REPO_URL"
```

You will use `$SESSION_NAMESPACE` throughout this workshop to give your Chainloop resources unique names — this prevents naming collisions when multiple participants run the workshop at the same time.

## Open the Workshop Chainloop Instance

Open the Chainloop Educates instance in a new browser tab. This is your hands-on workspace:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

{{< note >}}
Your browser and your terminal are two views of the same data. Commands you run in the terminal are immediately visible in the UI, and resources created through the UI can be managed from the CLI. You will use both throughout this workshop.
{{< /note >}}

You should now have two Chainloop browser tabs open: the **view-only** instance showing the production organisation, and the **Educates** instance where you will work. On the next page, you will create your first workflow and contract.
