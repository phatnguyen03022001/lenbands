# Pending Evidence Ledger

This mutable ledger lets the founder track outstanding evidence. Immutable evidence is stored only under `artifacts/operations/evidence/` and is never overwritten.

| Required evidence | Owner | Blocker |
|---|---|---|
| Real gold-standard corpus with rights/provenance | Founder | Writing evaluation contract, benchmark spec, P0-04/P0-06 |
| Benchmark intake manifest exists but is `missing`; case refs + examiner labels are still required | Founder/quality | `operations/benchmark/gold-corpus-manifest.yaml` |
| Numeric benchmark thresholds after a gold-standard baseline | Founder | Evaluation prompt/model route and release gate |
| Approval of candidate numeric-threshold policy + provider price version/cost ceiling | Founder | `operations/benchmark/numeric-threshold-policy.yaml`, `cost-budget.md` |
| Founder review of spawn reconciliation run-007 | Founder | Confirms framework 1.0.6 refs + asset revisions; static validation only, does not publish assets |
| Benchmark run record containing dataset/rubric/model/prompt versions | Founder/quality | Learner-facing evaluation promotion |
| P0-01..P0-06 runtime acceptance results | Engineering/operations | `operations/acceptance/p0-acceptance-manifest.yaml`; no runtime results yet |
| Exit Exercise A: export, restore, authorization, deletion | Founder + provider/privacy | Exit decision and closed-pilot identity gate |
| Exit Exercise B: provider-adapter switch and history preservation | Founder + engineering/provider | Provider/model promotion |
| Spawn-validation approval record | Founder | Confirms pipeline validation only; does not replace rights/content publication approval |
| Provenance/license evidence for 10 legacy vocabulary assets | Founder/content | Do not promote `unknown` sidecars to published |
| Rights/content review for 7 generated draft assets | Founder/content | Do not serve to learners or publish assets |

## Update rules

- While evidence is missing, keep the artifact in `review` or `draft`.
- Do not fabricate run records to clear the ledger.
- When real evidence appears, store an immutable snapshot and add its reference/hash to the affected artifact.
