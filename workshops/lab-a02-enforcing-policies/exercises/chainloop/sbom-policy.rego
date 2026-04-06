package chainloop

# valid_input guards against evaluating an empty attestation
valid_input := count(input.materials) > 0

# violations fires when no CycloneDX SBOM material is present
violations[msg] {
    not sbom_present
    msg := "A CycloneDX SBOM must be included in the attestation"
}

sbom_present {
    some material in input.materials
    material.type == "SBOM_CYCLONEDX_JSON"
}
