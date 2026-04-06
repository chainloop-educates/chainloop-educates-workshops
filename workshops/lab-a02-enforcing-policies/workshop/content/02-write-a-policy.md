---
title: Writing a Policy
---

Policies are Rego files that live alongside your workflow contract. They are referenced by file path in the contract — no separate upload step or registry is required. The exercises directory already contains a pre-prepared policy for this workshop.

## Read the Policy File

Open the policy:

```editor:open-file
file: ~/exercises/chainloop/sbom-policy.rego
```

## Walking Through the Policy

Let's examine each part.

**`package chainloop`**

Every Chainloop policy must use `package chainloop`. This is how Chainloop's evaluation engine identifies the policy entrypoints.

**`valid_input`**

```rego
valid_input := count(input.materials) > 0
```

This boolean guard returns `true` when the attestation contains at least one material. It prevents false positives: without it, an entirely empty attestation (no materials at all) would also trigger the violation, which could be misleading during pipeline setup.

**`violations[msg]`**

```rego
violations[msg] {
    not sbom_present
    msg := "A CycloneDX SBOM must be included in the attestation"
}
```

`violations` is a **set rule** — each entry is a string message describing a specific violation. Chainloop collects all entries in this set and reports them against the attestation. The rule fires whenever `sbom_present` is `false`. The violation message is what you will see in the Chainloop UI and in the audit trail.

{{< note >}}
Chainloop policies use `violations[msg]` rather than OPA-style `deny[msg]`. This is Chainloop's own convention — do not use `deny` here.
{{< /note >}}

**`sbom_present`**

```rego
sbom_present {
    some material in input.materials
    material.type == "SBOM_CYCLONEDX_JSON"
}
```

This helper rule iterates over `input.materials`. It returns `true` if any material has type `SBOM_CYCLONEDX_JSON` — Chainloop's identifier for a CycloneDX JSON SBOM. If no such material exists, `sbom_present` is `false`, and the `violations` rule fires.

## What This Policy Does Not Check

This policy only checks for *presence* of an SBOM — it does not inspect the SBOM's *content*. A more advanced material-level policy could evaluate the SBOM itself: for example, flagging components with known vulnerabilities, checking for banned licenses, or verifying that the SBOM was generated from the correct image digest. That kind of content inspection is a natural extension for a future workshop.
