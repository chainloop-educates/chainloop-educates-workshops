---
title: Triggering a Policy Violation
---

The pipeline currently produces an attestation with a container image but no SBOM. With the updated contract now in place, the policy will fire on the next pipeline run. Because enforcement is set to `block: false`, the pipeline will still succeed — but the violation will be recorded in the attestation and visible in the Chainloop UI.

## Clone the Repository

Check whether the repository is already cloned, and clone it if not:

```terminal:execute
command: ls ~/exercises/chainloop-demo 2>/dev/null && echo "already cloned" || git clone "$GITHUB_REPO_URL_GIT" ~/exercises/chainloop-demo
```

## Trigger the Pipeline

Push an empty commit to start a new pipeline run:

```terminal:execute
command: |-
  cd ~/exercises/chainloop-demo && \
  git commit --allow-empty -m "Trigger pipeline: policy violation demo" && \
  git push
```

## Watch the Pipeline in GitHub Actions

Open GitHub Actions to watch the workflow run:

```dashboard:open-url
url: https://github.com/chainloop-educates/chainloop-demo/actions
```

The workflow should complete successfully — the `block: false` enforcement mode means the missing SBOM does not cause a pipeline failure.

## Find the Violation in Chainloop

Once the pipeline completes, switch to the Chainloop browser tab and open the latest workflow run:

```dashboard:open-url
url: https://app.chainloop.dev/u/educates
```

Navigate to your workflow and open the most recent attestation. In the attestation detail view, look for the **policy evaluation results** section. You should see:

- Policy name: the name derived from `sbom-policy.rego`
- Status: **violation**
- Message: "A CycloneDX SBOM must be included in the attestation"

The attestation was accepted (the push succeeded), but the violation is permanently recorded against it.

{{< note >}}
This is the recommended approach for rolling out new policies in production: deploy in warn mode first, observe which pipeline runs produce violations, fix the pipelines, and only switch to block mode once you are confident the required evidence is being collected consistently.
{{< /note >}}
