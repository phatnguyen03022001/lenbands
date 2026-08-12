# Asset Manifests

The sidecar `knowledge-assets/**/<asset>.meta.yaml` is the canonical manifest paired with the `<asset>.md` payload. The global projection `KA-NNNNNN` is the asset's required identity; a centralized manifest in this folder is optional projection, not the SSOT.

Minimum sidecar:

```yaml
asset_id: KA-000001
type: lesson
status: draft
version: 0.1.0

derived_from: [KA.Lesson]
framework_refs:
  - file: grammar-band-framework
    version: 1.0.6
    nodes: [g_present_perfect]

origin:
  source: unknown
  license: unknown

integrity:
  checksum: sha256:...

governance:
  rights_status: verified
  review_status: draft

lifecycle:
  created_at: "2026-08-07T00:00:00Z"
  updated_at: "2026-08-07T00:00:00Z"
```

The manifest stores references (`workflow_run_id`, `prompt_template_id`, `prompt_hash`, `model`, `parameters`) instead of raw prompts or sensitive data.
