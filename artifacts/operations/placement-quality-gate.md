# Placement Quality Gate — P0

## Purpose

Prevent placement from creating Band/Gap/Initial Plan from an unpublished configuration, missing calibration, or insufficient data. This is a quality gate for `PLACE.*`, not a content asset or an official IELTS scoring claim.

## Admission rule

A placement configuration is selectable only when it has:

```yaml
configuration_version:
status: published
rights_status: verified
exam_module:
skill_coverage:
scoring_rule_version:
band_range_policy:
calibration_status: provisional | calibrated
quality_owner:
published_at:
```

`provisional` is allowed in the closed pilot when the learner sees clear disclosure and the result is not advertised as calibrated/official. `calibrated` is used only when method, sample, metric, date, and evidence reference are present.

## Result guardrails

| Condition | Required result |
|---|---|
| No published configuration | Do not start; CTA returns when the configuration is ready |
| Missing/invalid response | `insufficient_data`, explanation, and retry/resume |
| Calibration provisional | Result + confidence/provisional disclosure; no high-confidence readiness |
| Scoring rule/version missing | Block result and create operational alert |
| Module/skill coverage mismatch | Do not infer an overall band; show only the valid scoped result |
| Rights status non-verified | Do not serve/use the configuration |

## Measurements and promotion

- Track completion, invalid/insufficient rate, resume success, configuration/version distribution and plan-action completion.
- Calibration promotion requires a versioned run record in `operations/evidence/`; no prose-only promotion.
- Configuration/rule change requires regression comparison and invalidates cached placement result derivations as defined by Cache Contract.

## Acceptance conditions

- Every result is traceable to one config/scoring/calibration version.
- No result can claim overall/official confidence beyond its admitted coverage.
- Empty/unavailable configuration is learner-safe and cannot silently route to random task.
