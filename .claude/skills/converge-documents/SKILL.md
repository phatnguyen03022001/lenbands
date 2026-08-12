---
name: converge-documents
description: Drive global LenBands Blueprint and Artifact convergence across all 180 capabilities and every product, IELTS, UX, contract, NFR, governance and operations axis without writing application source code.
argument-hint: "[all or a bounded audit axis]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash, WebSearch, WebFetch, Agent
---

# Converge the complete document system

This is the default project workflow. It is not an implementation workflow.

1. Run `tools/bin/lenbands context --yaml`. Confirm the policy phase is
   `document_convergence`; if not, stop and report the policy inconsistency.
2. Inventory canonical owners and projections before writing. Use `repo-cartographer`
   read-only; never create a second owner to make a gap look closed.
3. Build an explicit gap ledger across every required axis:
   - 180 capabilities, families, phases, dependencies and traceability;
   - all roles (learner/founder/operator/content/quality), permissions and end-to-end journeys;
   - IELTS controlled vocabulary, band semantics, learning progression, practice,
     assessment, feedback, calibration and knowledge provenance;
   - information architecture, interaction/state/error/empty/loading/resume behavior,
     responsive design, localization and WCAG accessibility;
   - data, API, event, failure, privacy, consent, security and threat boundaries;
   - performance, reliability, idempotency, concurrency, observability, recovery,
     retention, portability and cost constraints;
   - prompt/model lineage, evaluation, hallucination controls, provider adapters,
     quota/economics and model promotion/rollback;
   - framework composition for Next.js, Go and Python, database/cache/object-store
     adapters, deployment, CI/CD, operations and release/rollback strategy;
   - acceptance design, benchmark design, rights/provenance and immutable evidence paths.
4. Fan out only disjoint read-only audits to `ielts-semantics-auditor`,
   `red-team-reviewer`, `verification-auditor` and `repo-cartographer`. The main session
   reconciles conflicts; agent consensus is not authority.
5. For each confirmed gap, resolve the existing canonical owner. Use
   `contract-deepener` on one editable owner at a time. Preserve versioning, sidecars,
   SSOT ownership, controlled vocabulary and explicit proposal/evidence status.
6. External facts require primary authoritative citations. Never copy licensed IELTS
   content, infer rights, invent examiner labels, or turn a source citation into evidence.
7. Protected Blueprint/authority changes must be returned as exact privileged-review
   diffs with rationale, affected projections and required validator changes. Never
   weaken a gate or bypass the hook to apply them.
8. After each coherent batch, independently red-team cross-owner contradictions,
   missing states, privacy leakage, framework reinvention and untestable language. Then
   run `tools/bin/lenbands verify` and `tools/bin/lenbands gate toolchain`.
9. Do not edit `apps/**`, `services/**` or `engines/**`; do not invoke implementation
   agents, dependency installation, build, runtime test or code-generation commands.
10. Continue until every global unlock criterion in the agent trust policy is supported
    by canonical documents and review evidence, or stop with a precise decision/evidence
    blocker owned by the founder or an external party. Never self-declare completion,
    approval, readiness, calibration, rights or “god level” from prose alone.

The final handoff must list owners deepened, conflicts resolved, validator coverage added,
remaining gaps by owner, privileged diffs, sources consulted, checks run, and why the
global source lock remains closed.
