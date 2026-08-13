# LenBands Decision Register
## v1.0.0 — Founder-Locked Decision-Phase Final / Pre-Canonical

**Document ID:** `LENBANDS-DECISION-REGISTER`  
**Version:** `1.0.0`  
**Generated:** `2026-08-12T16:08:43+07:00`  
**Owner:** Founder  
**Decision phase:** `CLOSED`  
**Founder-selected/locked decision rows:** **325**  
**Authority of current decisions:** `A1_FOUNDER_SELECTED_UNRECORDED`  
**Canonical repository authority:** `NOT YET A0 — reconciliation/adoption pending`  
**Implementation authorization:** `NOT GRANTED BY THIS FILE`  
**Self-integrity scheme:** SHA-256 over the full UTF-8 file after replacing the 64-hex value on the `SELF_SHA256:` line with 64 zeroes.  
**SELF_SHA256:** `858a1eeda8c40b2074dc2355fc41990d6845164ce474b6ee9c194d25a1409f41`

> This is the single-file founder-locked decision register for the current decision phase. It closes product/founder decision design through 10F. It does not fabricate repository-canonical adoption, legal approval, provider activation, calibration, validation, or implementation authority.

---

# 1. Executive Summary

| Round | Scope | Rows | Authority | Lifecycle |
| --- | --- | --- | --- | --- |
| V1 | Infrastructure principles | 12 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN |
| V2 | Runtime/reliability | 10 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN |
| V3 | Identity/privacy | 10 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN; legal review pending |
| V4 | Auth/session | 16 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN; activation blocked |
| V5 | Data/storage/queue/backup | 14 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN |
| V6 | AI/evaluation/cost architecture | 12 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN; calibration required |
| V7 | Provider topology | 12 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN; reconciliation/activation gates |
| V8 | Ops/recovery/security | 16 | A1_FOUNDER_SELECTED_UNRECORDED | CLOSED_FOR_DESIGN |
| V9 | Product/runtime architecture | 30 | A1_FOUNDER_SELECTED_UNRECORDED | CLOSED_FOR_PRODUCT_DESIGN |
| 10A | Construct → requirements | 15 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED |
| 10B | Intervention/mechanisms | 40 | A1_FOUNDER_SELECTED_UNRECORDED | CLOSED |
| 10C | Evidence/retest/transfer | 54 | A1_FOUNDER_SELECTED_UNRECORDED | CLOSED |
| 10D | Experience/transitions | 40 | A1_FOUNDER_SELECTED_UNRECORDED | CLOSED |
| 10E | Cost viability | 24 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED |
| 10F | Integrated coverage | 20 | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED / DECISION PHASE CLOSED |

### Decision totals

```text
Founder-selected / locked decision rows: 325
Open founder/product decisions in this phase: 0
Canonicalization blockers: 2
Implementation-spec blockers: 3
Production / claim / pricing / P1 blockers: 10
```

### State in one paragraph

LenBands now has a closed founder decision model from infrastructure and identity through product architecture, construct decomposition, intervention selection, evidence/readiness semantics, learner experience, cost viability, and integrated coverage. `10F.1–20` is founder-locked in this version, so the current decision phase is closed. Remaining work is **not more founder ontology design**: it is canonical repository reconciliation, implementation specification, provider/legal activation, calibration/validation, production testing and pricing execution.

### Non-claims

This file does **not** establish:

- A0 canonical repository authority;
- protected mutation authorization;
- provider procurement/DPA approval;
- runtime production readiness;
- calibrated numeric thresholds;
- validated educational outcomes;
- guaranteed IELTS band outcomes;
- legal approval for minors/content/provider processing.

---

# 2. Authority, Lifecycle and Founder Sign-Off

## 2.1 Authority classes

| Class | Meaning |
|---|---|
| `A0_CANONICAL` | Approved repository/governance authority. |
| `A1_FOUNDER_SELECTED_UNRECORDED` | Founder-selected/locked decision not yet adopted into A0. |
| `A2_SOURCE_BASELINE` | Existing source/pre-code/review decision artifact. |
| `A3_ADVISORY_PROPOSAL` | Proposal/research/recommendation; no implementation authority. |

All current decision rows V1–10F in this file are `A1_FOUNDER_SELECTED_UNRECORDED`.

## 2.2 Lifecycle

Lifecycle is orthogonal to authority:

`OPEN`, `LOCKED_FOR_DESIGN`, `CLOSED_FOR_DESIGN`, `PENDING_RECONCILIATION`, `ACTIVATION_BLOCKED`, `CALIBRATION_REQUIRED`, `VALIDATION_REQUIRED`, `SUPERSEDED`, `PENDING`.

A closed A1 decision is not automatically A0 canonical.

## 2.3 Founder approval event

**Approval event ID:** `FOUNDER-CHAT-2026-08-12T16:05+07:00`  
**Approval basis:** immediately after stating that a 10/10 register requires (a) fixed numbering, (b) founder lock of `10F.1–20`, and (c) founder sign-off, the founder instructed that the required deliverable is **“1 file duy nhất 10/10.”**  
**Recorded scope of this approval:** issue a single-file final register, lock `10F.1–20` unchanged from the reviewed v0.3.0 proposal, close the current decision phase, and freeze the resulting content under the self-hash in Document Control.  
**Authority effect:** `10F.1–20: A3 → A1`, lifecycle `OPEN → LOCKED/CLOSED_FOR_DESIGN`.  
**Non-effect:** this approval is **not** a digital signature, A0 repository adoption, legal sign-off, activation approval, or implementation authorization.

### Founder sign-off record

```text
Founder approval source:
FOUNDER-CHAT-2026-08-12T16:05+07:00

Approved scope:
V1–10F consolidated decision phase
including 10F.1–20 unchanged

Frozen artifact:
LenBands Decision Register v1.0.0

Integrity binding:
SELF_SHA256 in this file
```

If the founder later states that this approval-event interpretation was not intended, v1.0.0 must be superseded rather than silently edited.

---

# 3. Read Order and Decision Dependency Graph


```text
FOUNDATION / OPERATIONS

V1 Infrastructure ──► V2 Runtime ──► V5 Data ──┐
        │                 │                     │
        │                 └────► V6 AI ───────┤
        │                                      ▼
V3 Identity/Privacy ──► V4 Auth/Session ──► V7 Provider Topology
                                               │
                                               ▼
                                      V8 Operations/Recovery
                                               │
                                               ▼
                                        Activation Gates


PRODUCT / LEARNING

V9 Product Architecture
        │
        ▼
10A Construct → Performance Requirements
        │
        ▼
10B Gap → Action Intent → Intervention
        │
        ▼
10C Evidence / Retest / Sufficiency
       / \
      ▼   ▼
10D Experience   10E Cost Viability
      \           /
       └────┬────┘
            ▼
      10F Integrated Coverage
            │
            ├──► Target Coverage Matrix
            ├──► CoverageGap Register
            ├──► Demand Register
            ├──► TargetSupportDeclaration
            └──► Validation Backlog

Rights / privacy / reliability are hard gates across provider,
intervention, evidence, experience, coverage and activation.
```

---

# 4. Glossary

| Term | Canonical working meaning |
| --- | --- |
| TargetProfile | Versioned learner/product target constraints, e.g. test variant, overall/skill minima and purpose. |
| PerformanceRequirement | Smallest operationally useful target-performance requirement derived from construct evidence. |
| Competency | LenBands curriculum capability used for learning/evidence/planning; not automatically an IELTS task label. |
| ObservableBehaviour | Performance that can be observed and connected to a requirement/competency. |
| PerformanceContext | Composable material conditions under which performance occurs, e.g. task demand, timing, support, novelty. |
| EvidenceRequirement | Specification of what evidence would be relevant/sufficient for a scoped claim. |
| Observation | Recorded result/feature of an attempt before evidence admission. |
| EvidenceEligibility | Claim/purpose-scoped decision about whether an observation may be used as evidence. |
| EvidenceFact | Historical admissible observation; not mastery and not a competency-demonstrated assertion. |
| Evidence attribution | Versioned N:M mapping/interpretation by which EvidenceFacts support/contradict/inform claims. |
| MasteryEstimate | Versioned, uncertainty-aware derived learner state from evidence; not a raw evidence container. |
| PerformanceEvidenceProfile | Claim-relevant derived view of current evidence supporting readiness evaluation. |
| ReadinessSpecification | Logical semantic conditions/blockers for a scoped readiness claim; specification precedes numeric calibration. |
| TargetReadinessEvaluation | Individual learner readiness interpretation: INSUFFICIENT/CONFLICTING/STALE/NOT_YET_SUPPORTED/SUPPORTED. |
| GapEvaluation | Learner-specific gap/uncertainty state derived from readiness/mastery evidence; distinct from product CoverageGap. |
| ActionIntent | Planner objective implied by learner state: REMEDIATE, COLLECT_EVIDENCE, RESOLVE_CONFLICT, REASSESS, EXPAND_CONTEXT. |
| Intervention | Candidate learning/evidence strategy selected for a learner gap; distinct from mechanism/activity/asset. |
| LearningMechanism | Mechanism such as retrieval, worked example, contrast, guided production; not a UI or asset. |
| ActivityPattern | Executable learning interaction pattern that instantiates one or more mechanisms. |
| ScaffoldingProfile | Composable support context: content/structure/lexical/response/feedback/attempt/timing supports. |
| CoverageGap | Product-level missing/failed integrated coverage condition; never evidence of learner weakness. |
| TargetCoverageSpecification | Versioned logical coverage contract for a target/requirement scope. |
| AssetDemand | Content/media/item demand derived from a coverage hole after non-asset demand classification and reuse checks. |
| SUPPORTED_FOR_PRODUCT | Product may support/expose a scoped target under its TargetSupportDeclaration; distinct from learner SUPPORTED. |
| VALIDATED | Scoped/versioned empirical claim; not an architecture-quality label. |
| CostViabilityEvaluation | Scenario-scoped viability under entitlement, usage, scale, reliability and quality assumptions. |
---
---

# 5. Invariant Index — Single Source Within This File

Other sections do not restate these rules; they cite this section.

## Governance

```text
Founder WHAT ≠ implementation HOW
Proposal ≠ authority
Selection ≠ activation
Lifecycle closed ≠ canonical authority
```

## Learning / evidence

```text
Band → performance target
Learner gap → curriculum

Practice ≠ Assessment
Response ≠ Observation
Observation ≠ EvidenceFact
EvidenceFact ≠ MasteryEstimate
MasteryEstimate ≠ ReadinessEvaluation
AI score ≠ Mastery

Evidence Requirement ≠ Evidence Eligibility
Missing evidence ≠ Negative evidence
Correctness ≠ Evidence Quality
Novelty ≠ Transfer
Learning Value ≠ Evidence Value
```

## Intervention / experience

```text
Intervention ≠ LearningMechanism
LearningMechanism ≠ ActivityPattern
ActivityPattern ≠ Asset

Uncertainty ≠ weakness
Ability gap ≠ prerequisite gap
Adaptive path ≠ adaptive target

Activity completion ≠ Learning success
Learning success ≠ Evidence success
Evidence success ≠ Readiness success

Friction/adherence ≠ ability evidence
Resume position ≠ evidence-context validity
Accessibility support ≠ automatically construct-preserving
UX clarity ≠ manufactured certainty/progress
```

## Coverage / cost

```text
Asset exists ≠ Coverage
Coverage ≠ aggregate percentage
Coverage ≠ SUPPORTED_FOR_PRODUCT
SUPPORTED_FOR_PRODUCT ≠ Learner SUPPORTED
SUPPORTED_FOR_PRODUCT ≠ VALIDATED
SUPPORTED ≠ guaranteed IELTS outcome

Cost cannot compensate for quality failure
Deterministic-first only when required quality is satisfied
Free/Premium share semantic truth + minimum quality floor
```

## AI authority

AI may generate, explain, score or route under approved contracts, but:

```text
AI ≠ curriculum truth owner
AI ≠ readiness-policy owner
AI-generated benchmark ≠ sole gold validation of that AI
```

---
---

# 6. Founder Decision Register — V1 through V10E

**Authority:** `A1_FOUNDER_SELECTED_UNRECORDED`  
**Invariant reference:** Section 5.  
**Reading rule:** decision IDs are stable references; section numbers are unique hierarchical navigation.


## 6.1 V1 — Cloud / Infrastructure Principles

| ID | Decision | Rationale |
| --- | --- | --- |
| V1.1 | No hard data-residency requirement for early stage; Vietnam is the main initial market. | Avoid blocking pilot architecture before a verified legal/contractual residency requirement exists; still require privacy/legal review before activation. |
| V1.2 | First 6–12 month market primarily Vietnam. | Product, latency and support decisions should reflect the actual early market. |
| V1.3 | Managed vs self-hosted chosen per economics and quality. | Avoid ideological provider choices; use managed services where they reduce ops without failing portability/quality. |
| V1.4 | Hybrid vendor strategy: fewer vendors for core, flexibility for peripherals. | Reduce core operational blast radius without forcing inefficient consolidation. |
| V1.5 | Re-evaluate primary compute from scratch; do not inherit Cloud Run automatically. | Provider selection must follow current workload, cost, reliability and exit evidence. |
| V1.6 | PostgreSQL is the long-term canonical datastore. | Standards, relational integrity, migrations, backup/restore and provider exit are stronger than proprietary data models. |
| V1.7 | Closed-pilot core recovery target roughly <15 min; accepted learner submissions must not be lost. | Protect learner trust and durable work without active-active infrastructure. |
| V1.8 | Near-zero non-AI infra where practical; spend when reliability/quality/usage proves value. | Preserve runway while explicitly allowing stateful reliability spend. |
| V1.9 | Design initially for ~2,000–3,000 learners; later early-scale discussion extends planning to ~3,000–5,000, without a new exact canonical threshold. | Avoid both toy architecture and premature hyperscale design. |
| V1.10 | Mandatory portability boundaries: Database + AI + Identity. | These are the most strategically costly lock-in boundaries. |
| V1.11 | Privacy/legal/data safety are hard minimums; among eligible options prioritize reliability → cost → portability → speed. | Safety/quality must not become tradeable score components. |
| V1.12 | Production-shaped from the start, but do not overbuild. | Preserve operational discipline and migration paths while avoiding Kubernetes/microservice theater. |

---

---


## 6.2 V2 — Runtime Topology / Reliability

| ID | Decision | Rationale |
| --- | --- | --- |
| V2.1 | Accepted submissions use commit-before-ACK semantics. | A learner-visible success must correspond to durable application state. |
| V2.2 | AI outage → persist/queue/delay; fail over only to a pre-approved equivalent route. | Availability cannot silently lower scoring/evidence quality. |
| V2.3 | Environments: local + staging + production. | Separate testing and release risk without creating unnecessary environment sprawl. |
| V2.4 | PostgreSQL PITR required. | Recovery must cover operator/application failures beyond logical dumps. |
| V2.5 | General disaster RPO planning band ~15–60 min; accepted submission has stronger durability at commit boundary. | Separate disaster recovery objectives from no-loss accepted-work semantics. |
| V2.6 | Audio is ephemeral-by-default unless a future explicit retained-recording policy is approved. | Minimize sensitive-data retention and storage cost while preserving feedback/recovery paths. |
| V2.7 | Critical infrastructure as code; peripheral dashboard configuration may remain manual. | Audit and portability matter most on critical infrastructure; avoid ceremony for low-risk settings. |
| V2.8 | Cheaper/lower-reliability provider allowed only with an adequate recovery/fallback path and unchanged quality floor. | Cost may not create silent correctness degradation. |
| V2.9 | Portable compute; production may remain single-cloud. | Portability is required; active multi-cloud is not. |
| V2.10 | Moderate ops complexity may be accepted to save cost when reliability/maintainability remains justified. | Optimize total operating economics, not vendor count alone. |

---

---


## 6.3 V3 — Identity / Privacy Principles

| ID | Decision | Rationale |
| --- | --- | --- |
| V3.1 | Email/password is the main learner login; Google/Facebook optional. | Own a universal login path and avoid social-provider dependence. |
| V3.2 | Credential custody resolved later through Auth0 selection. | Managed credential handling reduces password-security burden while preserving an identity adapter boundary. |
| V3.3 | Guest trial allowed; retention/merge behavior must be subtle and research-driven. | Reduce acquisition friction without silently merging identities or manipulating retention. |
| V3.4 | User-request deletion, subject to lawful/security retention categories. | Respect deletion rights without pretending immutable/security records can always be instantly rewritten. |
| V3.5 | Full machine-readable export required. | Identity/data portability is a hard product boundary. |
| V3.6 | Derived progress/results may be retained; raw/intermediate learner content is adaptively cleaned. | Keep longitudinal learning value while minimizing unnecessary sensitive content. |
| V3.7 | Audio ephemeral-by-default; local replay/download where possible; temporary server processing/recovery; auto-delete unless separately approved. | Privacy, cost and trust improve when recording retention is not the default. |
| V3.8 | AI processor training/reuse prohibited or highly restricted by default (`training_by_processor_allowed=false`). | Learner content must not become provider training data through a default setting. |
| V3.9 | Minimal pilot analytics; no raw learner content. | Product analytics should not become a secondary content repository. |
| V3.10 | Minors are supported, triggering additional consent/privacy/legal review. | Minors change legal and product-safety constraints and cannot be treated as an adult-only afterthought. |

---

---


## 6.4 V4 — Authentication / Session Model

| ID | Decision | Rationale |
| --- | --- | --- |
| V4.1 | Email/password mandatory/main. | Consistent with V3 and usable without social identity. |
| V4.2 | Managed credentials via Auth0 selection. | Reduces password storage/security burden while preserving internal learner identity. |
| V4.3 | Existing valid sessions should survive temporary IdP outage where safely possible. | Avoid coupling every authenticated request to live IdP availability. |
| V4.4 | Learner session horizon ~30 days. | Balance learner convenience with revocable server-side sessions. |
| V4.5 | Logout-all-devices required. | User must be able to invalidate active refresh sessions. |
| V4.6 | Password change/compromise revokes all refresh sessions. | Credential compromise must invalidate long-lived session material. |
| V4.7 | Guest → account merge requires explicit user confirmation. | Avoid accidental identity/data merges. |
| V4.8 | Same-email identities are not auto-linked; any later linking requires explicit secure re-authentication. | Email equality is not sufficient proof of account ownership. |
| V4.9 | Unverified users may learn; sensitive features remain restricted. | Reduce onboarding friction while reserving higher-risk actions for verified accounts. |
| V4.10 | Password reset via email OTP. | Simple recovery path consistent with email/password primary auth. |
| V4.11 | Admin identity is a separate security boundary. | Privileged access should not inherit learner-account assumptions. |
| V4.12 | Learners have no mandatory MFA by default. | Avoid disproportionate friction for general learners. |
| V4.13 | Access token target ~1 hour. | Bound bearer-token lifetime without excessive refresh churn. |
| V4.14 | Opaque rotating/revocable refresh sessions, stored server-side; persist token hash, not raw refresh token. | Support device revocation and reduce secret-at-rest risk. |
| V4.15 | Learning domain references stable internal `learner_id`, not provider IDs. | Identity provider changes must not rewrite the learning domain. |
| V4.16 | Admin new/untrusted device requires email OTP confirmation. | Founder-selected low-friction step-up for new devices; does not claim email OTP is a strong independent MFA factor. |

---

---


## 6.5 V5 — Data / Storage / Queue / Backup

| ID | Decision | Rationale |
| --- | --- | --- |
| V5.1 | PostgreSQL owns canonical structured product/domain state. | One relational authority simplifies integrity, migrations and recovery. |
| V5.2 | Analytics may be logically separate but never owns canonical product facts. | Analytic convenience must not redefine learner state. |
| V5.3 | Redis outage must not break critical correctness; DB-backed critical flows continue. | Cache/dispatch is disposable relative to canonical state. |
| V5.4 | Transactional PostgreSQL outbox + dispatch layer. | Persist business state and publication intent atomically. |
| V5.5 | Worker death → automatic retry. | Async evaluation must recover from ordinary worker failure. |
| V5.6 | Retries are bounded, classified transient/permanent/ambiguous, idempotent and cost-aware. | Prevent retry storms, duplicate charges and false recovery. |
| V5.7 | One private object store with policy namespaces. | Keep storage operationally simple while separating retention/access rules. |
| V5.8 | PITR + daily independent logical backup. | Provider-native recovery plus provider-independent exit/recovery copy. |
| V5.9 | Independent backup must be outside the DB provider. | A provider incident must not destroy both primary and only backup. |
| V5.10 | Automated restore verification + periodic full disaster drill. | Backup existence is not recovery evidence. |
| V5.11 | Minimal analytics/structured events; no raw-content firehose. | Protect privacy and reduce unnecessary observability cost. |
| V5.12 | Derived progress/results long-lived; raw/intermediate learning data short-lived/adaptive. | Data retention follows learning value and sensitivity. |
| V5.13 | Persist state + outbox transaction before publication; broker is not authority. | Messaging failure must not erase accepted product facts. |
| V5.14 | Restore must reapply deletion semantics; deleted media/content must not become immortal through backups. | A restore cannot resurrect user-deleted data into normal product use. |

---

---


## 6.6 V6 — AI Evaluation / Cost Architecture

| ID | Decision | Rationale |
| --- | --- | --- |
| V6.1 | Flash-first evaluator; stronger/Pro route only for hard cases. | Control variable AI cost while preserving an escalation path. |
| V6.2 | Disagreement handling depends on risk/level. | Not every disagreement deserves the same spend or workflow. |
| V6.3 | Asynchronous evaluation acceptable; show truthful coarse states instead of forcing low latency at quality expense. | Learner trust is better served by durable work and truthful delay than rushed scoring. |
| V6.4 | 5–10× stronger-model cost is acceptable only for justified hard cases. | Spend follows marginal value/risk. |
| V6.5 | Second pass only for high-risk/high-uncertainty cases. | Avoid doubling cost on routine evaluations. |
| V6.6 | Feedback is progressive: summary/main issues first, drill-down optional. | Reduce cognitive load and runtime generation cost. |
| V6.7 | Precompute reusable curriculum/explanations; generate personalized fragments at runtime. | Move repeatable work offline and stabilize quality. |
| V6.8 | Speaking uses staged STT/features + AI/multimodal where required, not a single black-box score. | Keep evidence provenance and cost control by criterion/stage. |
| V6.9 | Free may include meaningful AI allowance but must remain sustainable. | Free must demonstrate the real learning loop without unlimited expensive inference. |
| V6.10 | Quota pressure may choose cheaper only if the calibrated quality floor still passes. | Cost cannot lower rubric/evidence integrity. |
| V6.11 | Offline/batch generation and benchmark work allowed when learner-visible latency is irrelevant. | Move expensive noninteractive work out of the critical path. |
| V6.12 | Provider routing uses hard privacy/quality/reliability eligibility before cost optimization. | Provider price never overrides minimum trust/quality constraints. |

---

---


## 6.7 Content Rights / Commercial Curriculum

### Spotify

**Decision:** remove Spotify from the LenBands core/integrated content strategy.

**Rationale:** commercial/platform/minor/AI-ingestion restrictions add product risk without unique enough learning value to justify the dependency.

### Rights-first content factory

```text
rights-cleared factual/reference source
        ↓
FactBundle / source provenance
        ↓
original LenBands asset generation
        ↓
similarity + factuality + rights QA
        ↓
versioned commercial asset
```

Never treat “free to access” as “commercially reusable,” and never treat AI paraphrasing as a rights-clearing mechanism.

### Rights classes

| Class | Default handling |
|---|---|
| `GREEN` | LenBands-owned, CC0, verified public domain, CC BY, or explicit commercial licence; still enforce attribution/other terms. |
| `AMBER` | CC BY-SA, mixed/uncertain rights, publicity/trademark/person issues, jurisdiction uncertainty; require review. |
| `RED` | Non-commercial licences, restricted IELTS practice, TED/restricted content without permission, random YouTube transcripts, copyrighted/paywalled works without rights; do not use as paid generation seed. |

### Authority separation

```text
Official IELTS
→ construct/task/criteria reference

Open / licensed sources
→ factual/media substrate

AI
→ generation/adaptation tool

LenBands evidence + rights review
→ product admission / validation
```

External popularity does not become rights authority or curriculum truth.

---

---


## 6.8 V7 — Provider Architecture Selection

All rows in this current V7 table are founder-selected A1 decisions; lifecycle/reconciliation/activation states vary independently.

| Boundary | Current decision/direction | Authority | Lifecycle | Rationale |
| --- | --- | --- | --- | --- |
| Identity | Auth0 | A1_FOUNDER_SELECTED_UNRECORDED | ACTIVATION_BLOCKED | Managed credential boundary; identity portability retained through internal learner ID and standards/exit requirements. |
| API / evaluation workers | Cloud Run in Singapore | A1_FOUNDER_SELECTED_UNRECORDED | PENDING_RECONCILIATION / benchmark before final provisioning | Container portability, scale-to-zero economics and single-region simplicity. |
| Frontend | Next.js on Cloudflare Workers/OpenNext; static-first/edge-first | A1_FOUNDER_SELECTED_UNRECORDED | PENDING_RECONCILIATION | Avoid first-page dependence on scale-to-zero backend; dynamic Next.js belongs on Workers/OpenNext rather than treating Pages as universal SSR host. |
| Region | Singapore for compute + Postgres | A1_FOUNDER_SELECTED_UNRECORDED | BENCHMARK_REQUIRED | Colocate API/DB hot path; exact latency numbers are not canonical until measured. |
| Postgres | Neon PostgreSQL | A1_FOUNDER_SELECTED_UNRECORDED | ACTIVATION_BLOCKED | Standard PostgreSQL, low early cost, PITR/branching convenience behind an exit boundary. |
| Independent backup | Neon PITR + encrypted logical backup outside Neon, currently R2 direction | A1_FOUNDER_SELECTED_UNRECORDED | ACTIVATION_BLOCKED | Provider-independent recovery and exit path. |
| Object storage | Cloudflare R2 | A1_FOUNDER_SELECTED_UNRECORDED | ACTIVATION_BLOCKED | Private S3-compatible storage and favorable early egress economics. |
| Redis | Do not provision initially; Postgres outbox first | A1_FOUNDER_SELECTED_UNRECORDED | PENDING_RECONCILIATION | YAGNI; Redis is not authority and should enter only after measured throughput need. |
| Admin auth | Same IdP may be used with separate application/policy boundary; new-device email OTP | A1_FOUNDER_SELECTED_UNRECORDED | ACTIVATION_BLOCKED | Separate privileged boundary without unnecessary second identity vendor. |
| Staging | Scale-to-zero; separate DB branch/project | A1_FOUNDER_SELECTED_UNRECORDED | PENDING_SPEC | Production-shaped validation at low standing cost. |
| IaC | OpenTofu/Terraform for critical infra | A1_FOUNDER_SELECTED_UNRECORDED | PENDING_SPEC | Portability/auditability with low proprietary coupling. |
| Provider rule | Measured total-cost scorecard after eligibility; no fixed `$10` rule | A1_FOUNDER_SELECTED_UNRECORDED | LOCKED_FOR_DESIGN | Avoid choosing on free-tier headlines or arbitrary price deltas. |

### Lock-in claim

Do **not** say “zero vendor lock-in.”

Approved working language:

> **Critical data/domain contracts are portable; provider-specific operational conveniences are allowed behind explicit exit boundaries.**

---

---


## 6.9 V8 — Observability / Recovery / Security Operations

| ID | Decision | Rationale |
| --- | --- | --- |
| V8.1 | Severity-based escalation (`C`). | Operational response should reflect user/data/security impact rather than alert every issue equally. |
| V8.2 | PostHog-first observability; Sentry supplementary only when needed (`B`). | Minimize vendor/telemetry duplication while retaining an escalation path. |
| V8.3 | Adaptive log retention (`D`). | Security/audit and ordinary application telemetry have different retention needs. |
| V8.4 | Privileged admin audit log (`A`). | Privileged changes require accountable history independent of product analytics. |
| V8.5 | Staging auto-deploy; production manual approval during early stage (`B`). | Preserve fast feedback while protecting production during immature release evidence. |
| V8.6 | Auto rollback for clear technical failure; controlled/manual handling for semantic/data issues (`C`). | Automatic downgrade scripts can worsen schema/data incidents. |
| V8.7 | Expand/contract migrations (`C`). | Maintain backward compatibility across releases and avoid destructive coupled deploys. |
| V8.8 | Weekly restore verification + quarterly full disaster drill (`B`). | Continuous recoverability evidence without daily full-drill burden. |
| V8.9 | Fallback only for critical boundaries (`B`). | Avoid hot-fallback theater on every provider. |
| V8.10 | Provider exit test (`A`). | Portability must be exercised, not merely documented. |
| V8.11 | Limited risky-feature flags (`A`). | Enable staged release/rollback for evaluator, provider route, scoring, audio and pricing/quota policy. |
| V8.12 | Emergency kill switches (`A`). | Risky runtime paths must be stoppable without ordinary code deploy latency. |
| V8.13 | Subsystem-aware degraded/maintenance mode (`C`). | Keep safe product surfaces available while blocking unsafe writes. |
| V8.14 | Incident runbook by incident/secret class (`C`). | Credential leak, provider outage and data incidents require different actions. |
| V8.15 | Immediate production deletion + immutable backup + tombstone replay (`A/C hybrid`). | Respect deletion in live product without corrupting immutable recovery copies. |
| V8.16 | Internal status dashboard during closed pilot (`B`). | Public status infrastructure is unnecessary before public scale. |

---


## 6.10 V9 — Product / Runtime Architecture

| ID | Decision | Rationale |
| --- | --- | --- |
| V9.1 | Today-first home (`D`). | The system should answer “what should I do today?” instead of forcing learners to browse a library. |
| V9.2 | IELTS Skills + Supporting Skills (`C`). | Keep exam skills distinct from Vocabulary/Grammar/Pronunciation without leaking backend ontology. |
| V9.3 | Practice by training goal (`C`). | Learners choose what to improve, not navigate a database schema. |
| V9.4 | Listening = task practice + micro-skill drills + enrichment (`C`). | Combine exam familiarity, targeted remediation and broader listening development. |
| V9.5 | Listening audio hybrid TTS + human/curated high-value assets (`C`). | Use scalable audio generation without making all benchmark/high-value content synthetic. |
| V9.6 | Listening feedback = evidence segment + explanation + diagnosis + retry (`C`). | Wrong/right alone does not close the learning loop. |
| V9.7 | Reading progression micro → short → full → timed (`C`). | Build capability before demanding full exam performance. |
| V9.8 | Cover canonical task families in priority waves (`C`). | Model full construct while releasing production coverage honestly. |
| V9.9 | N:M evidence attribution (`C`). | One response can inform several capabilities; task label alone is too coarse. |
| V9.10 | Writing progresses sentence/paragraph/components → full essay (`C`). | Target isolated production gaps before integrated performance. |
| V9.11 | Progressive criterion feedback + priorities/evidence/drills (`C`). | Feedback must lead to action rather than a static AI report. |
| V9.12 | Targeted rewrite → paragraph/full rewrite loop (`C`). | Use feedback to create new production, not passive reading. |
| V9.13 | Speaking progresses Part 1/2/3 + supporting drills → full mock (`C`). | Do not make full mock the primary learning mechanism. |
| V9.14 | Record/replay/download; temporary server audio; persist result/evidence (`C`). | Preserve learner control and data minimization. |
| V9.15 | Pronunciation target indicators; numeric only after calibration (`C`). | Avoid pseudo-precision and accidental IELTS-band implication. |
| V9.16 | Vocabulary graph Lexeme → Sense → Collocation → Usage → Context → Recognition/Production (`C`). | Band/topic are views over language knowledge, not the ontology root. |
| V9.17 | Grammar = structured curriculum + error-driven + skill-context practice (`C`). | Combine systematic coverage with learner-specific remediation and transfer. |
| V9.18 | Progressive diagnostic / provisional profile (`C`). | A short first test cannot truthfully know the entire learner. |
| V9.19 | Task → section → skill → full mock hierarchy (`C`). | Provide assessment granularity between practice and full IELTS. |
| V9.20 | Practice performance separate from IELTS estimate (`C`). | Prevent small practice sets from masquerading as official band estimates. |
| V9.21 | Mastery represented as evidence/context-derived estimate (`D`, refined). | Competency is learned object; evidence supports an uncertain, versioned estimate. |
| V9.22 | Mastery is time/evidence-sensitive; no fixed decay formula (`B`). | Forgetting/staleness matters, but coefficients require data. |
| V9.23 | Daily Plan uses target gap + weakness + due review + available time + prerequisites (`D`). | Plan should allocate effort to the best current learning need under real constraints. |
| V9.24 | Strong recommendation with Swap/Skip/Shorten/Change-skill control (`C`). | Preserve learner agency without turning planner into decoration. |
| V9.25 | Progress is action-first; band/skill charts secondary (`D`). | Learner needs target → gap → priority → next action more than pseudo-analytics. |
| V9.26 | Gentle consistency; no punitive streak (`C`). | Support adherence without turning missed days into punishment. |
| V9.27 | Typed review by learning/evidence type (`C`). | Vocabulary, grammar, reading misconceptions, writing issues and speech issues need different review mechanisms. |
| V9.28 | Free includes a real learning loop (`C`). | Free must demonstrate product value, not merely sample content. |
| V9.29 | Premium sells depth/personalization/assessment/analytics, not AI tokens (`C`). | Protect product identity as a learning system instead of AI wrapper. |
| V9.30 | North Star = Adaptive IELTS Learning System (`C`). | All prior decisions converge on a closed evidence-driven learning loop. |

---


## 6.11 V10A — Construct → Performance Requirements

| ID | Decision | Rationale |
| --- | --- | --- |
| 10A.1 | Model Academic + General Training; initial release may be Academic-first. | Avoid hard-coding Academic into the domain while keeping launch scope realistic. |
| 10A.2 | TargetProfile is a constraint profile, not one overall band. | Real targets may require overall + minimum skill constraints. |
| 10A.3 | Model full band scale; support/coverage released honestly in waves. | Semantic representation should not pretend uncovered bands are production-supported. |
| 10A.4 | Listening/Reading requirements derive from stated abilities + task contexts. | Task-family names are formats, not automatically capabilities. |
| 10A.5 | Task family is not a competency by default. | Prevent ontology from mirroring exam UI rather than learnable capability. |
| 10A.6 | Writing criterion → observable performance requirements, scoped by Task 1/2. | Criteria are assessment dimensions; curriculum needs observable behaviors underneath. |
| 10A.7 | Speaking criterion × Part performance demands. | Part is elicitation context, criterion is assessment dimension, competency is derived later. |
| 10A.8 | Timing is a context condition only when construct requires it. | Do not manufacture time pressure for knowledge acquisition. |
| 10A.9 | Independent/unsupported performance required when target claim requires independence. | Guided success must not equal readiness. |
| 10A.10 | Same-item retry = recovery/learning; readiness/generalisation needs appropriate re-evidence. | Prevent memorized correction from becoming transfer evidence. |
| 10A.11 | Receptive readiness not inferred directly from practice % correct. | Correctness alone lacks context/coverage/independence/transfer semantics. |
| 10A.12 | Overall readiness derives from TargetProfile constraints + skill evidence, not average mastery numbers. | Respect skill minima and scoped evidence. |
| 10A.13 | Requirement granularity = smallest operationally useful unit. | Avoid both criterion-level coarseness and atomic-node explosion. |
| 10A.14 | Public band descriptors are construct evidence, not curriculum truth. | IELTS defines performance; LenBands designs learning progression. |
| 10A.15 | Every performance requirement has provenance + interpretation/validation status. | Separate direct source claims from LenBands derivation/hypothesis. |

---

---


## 6.12 V10B — Gap → Action Intent → Intervention / Learning Mechanisms

### Interview 1
| ID | Decision | Rationale |
| --- | --- | --- |
| 10B.1 | Ability gap → diagnose failure pattern; prerequisite only if implicated. | Wrong does not automatically mean missing prerequisite. |
| 10B.2 | Worked example → controlled → guided → fade → independent → transfer, with stages skippable when evidence supports. | Provide an acquisition path without forcing already-demonstrated steps. |
| 10B.3 | Retention/recall gap → retrieval + spaced practice candidate. | Use mechanisms aligned to retrieval failure rather than reteaching by default. |
| 10B.4 | Spacing applies only to suitable reviewable learning units, not every mistake. | FSRS-like scheduling requires discrete repeatable retrieval semantics. |
| 10B.5 | Discrimination gap → contrastive examples → explanation → varied context → independent application. | Near-alternative errors require discrimination, not merely more same-format items. |
| 10B.6 | Production gap → recognition → controlled → guided → independent → unseen production. | Recognizing quality is not equivalent to producing it. |
| 10B.7 | Scaffolding dependence → identify carrying support → selectively fade → re-evidence. | Remove the support actually responsible for performance, not all help at once. |
| 10B.8 | Transfer gap → variation → interleaving → unseen transfer. | More same-pattern practice does not test generalisation. |
| 10B.9 | Insufficient evidence → low-friction uncertainty-reducing diagnostic. | Unknown is an evidence problem, not a remediation command. |
| 10B.10 | Conflicting evidence → discriminating task/hypothesis test. | Resolve the reason for inconsistency instead of averaging it away. |
| 10B.11 | Stale evidence → targeted reassessment before remediation. | Old evidence does not prove deterioration. |
| 10B.12 | Intervention failure → classify failure mode → change action space. | Do not repeat the same intervention indefinitely. |
| 10B.13 | Learner preference is a suitability signal only. | Preference may improve adherence but cannot override prerequisites/quality/contraindications. |
| 10B.14 | Mechanism diversity only when justified by diminishing returns/transfer/repetition. | Do not randomize learning merely to look varied. |
| 10B.15 | Adaptive acceleration skips/compresses unnecessary stages when evidence supports it. | Strong learners should not replay the whole curriculum. |
| 10B.16 | When learner struggles, retain target; decompose/scaffold and use nearer-term subgoal. | Adapt the path, not the target, unless the learner explicitly changes the goal. |

### Interview 2
| ID | Decision | Rationale |
| --- | --- | --- |
| 10B.17 | Active retrieval for appropriate learned/reviewable knowledge; application follows when target requires production. | Retrieval supports recall, but complex performance still needs contextual production/transfer. |
| 10B.18 | FSRS-like scheduling only for reviewable learning units with repeated retrieval events and updateable recall state. | Use scheduler semantics where there is a meaningful discrete review object. |
| 10B.19 | Worked examples include attention guidance/comparison then fade. | Model answers should teach relevant features, not invite memorization. |
| 10B.20 | Contrastive practice for near alternatives/discrimination gaps. | Make the discriminating cue observable. |
| 10B.21 | Dictation only when failure implicates decoding/segmentation/detail perception. | Dictation is not a universal Listening curriculum. |
| 10B.22 | Shadowing only for relevant pronunciation/prosody/fluency targets. | Shadowing success does not prove independent Speaking readiness. |
| 10B.23 | Controlled production bridges recognition → production. | Constrain output enough to practice the intended form before free performance. |
| 10B.24 | Guided production uses failure-relevant support and fades selectively. | Scaffolding should target the actual production bottleneck. |
| 10B.25 | Rewrite/re-record only when corrected production has learning value for the gap. | Do not force productive correction on every wrong answer type. |
| 10B.26 | Feedback depth adapts to failure type. | Avoid rigid “always reveal” or “always self-correct first” rules. |
| 10B.27 | Extensive input is a learning candidate for breadth/exposure; weak direct readiness evidence alone. | Exposure can improve learning without directly proving a target claim. |
| 10B.28 | Interleaving is purposeful and follows sufficient initial stability. | Random mixing can increase difficulty without improving discrimination. |
| 10B.29 | Difficulty progression follows learner evidence + target/context demands. | Band labels are not direct item-difficulty rules. |
| 10B.30 | Feedback timing follows activity intent. | Immediate feedback supports acquisition; delayed feedback protects independent evidence. |
| 10B.31 | Hint availability/use belongs to ScaffoldingProfile/evidence context. | A correct response after hint has different inference scope. |
| 10B.32 | Self-explanation only when it reveals useful reasoning/discrimination. | Use cognitive friction when it produces information/learning value. |
| 10B.33 | Reflection/metacognition is lightweight and event-triggered. | Avoid turning every question into a survey. |
| 10B.34 | Learner-generated output is a productive retrieval/elaboration candidate when feedback is feasible. | Generation can expose production gaps that recognition hides. |
| 10B.35 | Timing is relevant only when the target performance requirement makes it material. | Timed practice is context, not a universal learning mechanism. |
| 10B.36 | Full mock = assessment/re-evidence mechanism with learning side-effects. | Mocks are broad evidence tools, not substitutes for targeted intervention. |
| 10B.37 | Detect diminishing returns; no fixed diversity quota. | Mechanism change should follow plateau/transfer/friction signals, not arbitrary counts. |
| 10B.38 | Multi-mechanism sequences require declared candidate rationale; plausibility ≠ validated efficacy. | A coherent story is not causal evidence. |
| 10B.39 | AI tutor is delivery/runtime capability, not a learning-mechanism ontology root. | AI can instantiate worked examples, guided practice, role-play, explanation, etc. |
| 10B.40 | Gamification belongs to experience support, not mastery/readiness semantics. | XP/streak/badges must not become ability evidence. |

---


## 6.13 V10C — Evidence / Retest / Transfer Coverage

### Interview 1 — Evidence eligibility / provenance / retest foundations
| ID | Decision | Rationale |
| --- | --- | --- |
| 10C.1 | Observation does not automatically become EvidenceFact. | Evidence admission is governed and claim-scoped. |
| 10C.2 | Eligibility considers requirement/context/scaffold/feedback/timing/independence/quality/provenance. | Correctness alone is insufficient. |
| 10C.3 | Positive/negative observations require context/quality interpretation. | One wrong response or guided correct response is not a shortcut to ability state. |
| 10C.4 | Same-item retry preserves initial and post-feedback observations separately. | Do not rewrite history into the final answer only. |
| 10C.5 | EvidenceFact may have N:M attribution via governed rules. | One observation may inform multiple competencies. |
| 10C.6 | Task type does not directly prove competency. | Task labels are context, not mastery claims. |
| 10C.7 | Objective scoring certainty ≠ construct/readiness relevance. | A deterministically correct score can still be weak readiness evidence. |
| 10C.8 | Low-confidence Writing/Speaking AI observation does not become high-stakes evidence. | Escalate/re-evidence rather than average uncertainty away. |
| 10C.9 | Practice and assessment share Evidence model but differ by context/eligibility. | Avoid duplicate evidence ontologies. |
| 10C.10 | Immediate retry = recovery; readiness path routes to delayed/independent re-evidence. | Learning response is different from retained independent performance. |
| 10C.11 | Same-item retest may support recovery/retention; readiness/generalisation needs appropriate unseen/re-evidence. | Exposure changes what can be inferred. |
| 10C.12 | Unseen is described through relevant novelty dimensions. | Exact-item novelty alone does not imply transfer. |
| 10C.13 | Transfer is scoped evidence, not binary magic. | Record what generalisation was actually observed. |
| 10C.14 | Consistency is claim-dependent; numeric thresholds calibration-required. | Do not invent universal attempt counts. |
| 10C.15 | Historical EvidenceFact remains; current readiness support may become stale. | Staleness changes current inference, not historical fact. |
| 10C.16 | Conflicts are preserved and discriminated, not averaged away. | Contradiction may reveal a material context dimension. |
| 10C.17 | Historical and derived layers are independently versioned/provenanced. | Rule changes must be traceable. |
| 10C.18 | Policy/model changes preserve observation history and allow governed recomputation downstream. | Do not silently rewrite past observations. |

### Interview 2 — Evidence sufficiency / coverage
| ID | Decision | Rationale |
| --- | --- | --- |
| 10C.19 | Readiness sufficiency is condition evaluation, not a weighted scalar. | Avoid unvalidated readiness percentages. |
| 10C.20 | Evidence dimensions are candidate/claim-scoped, not universal. | Only material claim conditions become requirements. |
| 10C.21 | Ability evidence connects to observable behaviour/performance requirement. | Generic mastery scores are not enough. |
| 10C.22 | Unresolved required condition blocks the scoped target claim. | Do not average missing mandatory requirements away. |
| 10C.23 | Context coverage covers material dimensions declared by the requirement. | Context matters only where the construct/claim makes it material. |
| 10C.24 | Independent evidence required when target performance requires independence. | Guided practice cannot accumulate into independent readiness by arithmetic. |
| 10C.25 | Consistency only where claim requires stable/repeatable performance. | No hidden universal N. |
| 10C.26 | Recency depends on claim/stability; no universal window. | Different capabilities may have different freshness needs. |
| 10C.27 | Transfer required when claim implies generalisation. | Do not demand transfer for narrow practiced-item claims or omit it for broad capability claims. |
| 10C.28 | Record observed transfer scope + inference scope. | Avoid extrapolating beyond observed novelty/context. |
| 10C.29 | Evidence diversity only when broader generalisation/context coverage requires it. | Near-duplicate quantity is not broad coverage. |
| 10C.30 | Negative evidence is preserved and interpreted by construct relevance/context. | Wrong answers are not automatic blockers. |
| 10C.31 | Unresolved material conflict blocks support. | A majority vote cannot erase a meaningful contradiction. |
| 10C.32 | Missing observations → INSUFFICIENT_EVIDENCE; observed-below-requirement → NOT_YET_SUPPORTED. | Unknown and weak remain distinct. |
| 10C.33 | SUPPORTED = current admissible evidence sufficiently supports the scoped claim. | It is not a guaranteed future IELTS result. |
| 10C.34 | Scoped readiness judgments are allowed. | Parts of a target may be supported while the overall target remains unresolved. |
| 10C.35 | ReadinessSpecification declares semantic coverage/blockers, not numeric thresholds yet. | Specification precedes psychometric calibration. |
| 10C.36 | Near-complete evidence → collect the missing material evidence, not generic remediation. | Use evidence collection to close a coverage hole. |
| 10C.37 | Readiness provenance points to evidence/policy versions. | Every claim should be auditable. |
| 10C.38 | Readiness may be recomputed from preserved history under governed policy change. | Derived interpretation evolves; history remains. |

### Interview 3 — Retest / refresh / anti-over-testing
| ID | Decision | Rationale |
| --- | --- | --- |
| 10C.39 | Request new evidence when it has meaningful decision/information value. | Testing has learner and operational cost. |
| 10C.40 | Do not over-collect evidence when marginal decision value is low. | More evidence is not automatically better. |
| 10C.41 | Stale → smallest representative targeted refresh. | Refresh current support without unnecessary full diagnostics. |
| 10C.42 | Conflict → discriminating retest/hypothesis test. | Collect evidence that separates explanations, not random extra samples. |
| 10C.43 | Missing coverage → collect exactly missing evidence where possible. | Minimize burden after semantic sufficiency is respected. |
| 10C.44 | Remediation → immediate recovery + delayed re-evidence as claim requires. | Immediate success and retained performance answer different questions. |
| 10C.45 | Unseen material when the claim requires generalisation/transfer. | Do not require novelty mechanically. |
| 10C.46 | Learner burden/friction constrains evidence collection. | Evidence collection is not free to the learner. |
| 10C.47 | Exposure history changes admissibility/inference scope, not historical fact. | Repeated material may still support retention/recovery claims. |
| 10C.48 | No universal cooldown; interval is claim/object/policy dependent. | Delay length requires calibration. |
| 10C.49 | Diminishing information return → stop/switch evidence strategy. | Repeated similar tasks cannot resolve a different uncertainty. |
| 10C.50 | After intervention success choose consolidation/retest/transfer/next gap based on claim. | Learning success is not automatically readiness success. |
| 10C.51 | Supported readiness may later need refresh if current evidence becomes stale. | Stale support does not mean learner deteriorated. |
| 10C.52 | Full mock may provide broad integrated evidence. | Broad evidence does not guarantee fine-grained attribution. |
| 10C.53 | Learner may request reassessment; evidence semantics still govern. | Learner control does not override construct/eligibility. |
| 10C.54 | Stop evidence collection when uncertainty resolved/coverage satisfied/next evidence has poor value-to-burden tradeoff. | Anti-over-testing is decision-aware, not quota-only. |

---


## 6.14 V10D — Learner Experience / Transition Coverage

### Interview 1
| ID | Decision | Rationale |
| --- | --- | --- |
| 10D.1 | Unknown learner → short diagnostic → provisional profile → useful first action. | Do not block product value on a long initial test. |
| 10D.2 | Today activity has concise approved learner-facing rationale. | Explain action without exposing raw internal reasoning or inventing causal certainty. |
| 10D.3 | Before activity: concise goal + why-now + success meaning. | Learner should know purpose without ontology overload. |
| 10D.4 | Activity success does not automatically mean mastered. | Scope feedback to the actual supported claim. |
| 10D.5 | Failure-specific recovery path. | Error feedback should produce a useful next action. |
| 10D.6 | Insufficient evidence → explain need for a short targeted check. | Unknown must not be shown as weakness. |
| 10D.7 | Conflicting evidence → simple uncertainty message + targeted check. | Do not show false precision or raw contradiction analytics. |
| 10D.8 | Stale evidence → explain recency and reassess. | Do not claim learner got worse. |
| 10D.9 | Show a small ranked set of actionable blockers. | Avoid dumping ontology/weakness lists. |
| 10D.10 | Priority count is presentation policy; backend retains ranked priorities. | Usability research can change density without changing planner semantics. |
| 10D.11 | Explain meaningful planner redirects. | Do not create a constantly shifting Today plan or expose every ranking delta. |
| 10D.12 | Added scaffolding is support toward the same target. | Struggle changes the path, not the target. |
| 10D.13 | Accelerate past unnecessary stages when evidence supports it. | Make adaptation visible as earned acceleration. |
| 10D.14 | Swap/Skip/Shorten/Change skill allowed; recommendation remains meaningful. | Learner agency matters; override produces preference/history, not fake mastery. |
| 10D.15 | Acknowledge learning progress while distinguishing next evidence/readiness step. | Completion and learning progress are not readiness claims. |
| 10D.16 | Scoped readiness support communicated cautiously; never guaranteed band. | Preserve epistemic integrity in learner copy. |
| 10D.17 | Progress answers where/blocks/change/next. | Actionable understanding is primary; charts are secondary. |
| 10D.18 | No eligible action → safe fallback; distinguish uncertainty from product coverage defect. | Runtime AI must not invent missing curriculum truth. |

### Interview 2
| ID | Decision | Rationale |
| --- | --- | --- |
| 10D.19 | Progressive feedback disclosure. | Reduce cognitive load while retaining deeper explanation on demand. |
| 10D.20 | Feedback prioritizes actionable issue aligned to current intervention. | Do not let exhaustive error detection derail the learning objective. |
| 10D.21 | Do not correct every issue immediately. | Defer non-material errors when correction would overload the learner. |
| 10D.22 | Describe observed performance + actionable change. | Avoid identity/global weakness claims from one observation. |
| 10D.23 | Session composition follows available time + Action Intent + priority + prerequisites + stopping points. | No fixed 10/5/10 recipe. |
| 10D.24 | Learner may choose available time. | Planner should adapt to real time constraints. |
| 10D.25 | Short session chooses coherent valid action with safe stopping point. | Do not arbitrarily truncate an intervention sequence. |
| 10D.26 | Interruption/resume depends on activity semantics and evidence-context validity. | Resume position does not guarantee readiness evidence continuity. |
| 10D.27 | Today plan stable enough to trust; replan only after material state change. | Avoid plan jitter while remaining adaptive. |
| 10D.28 | Preserve continuity and explain only meaningful redirect. | Reduce cognitive/context switching. |
| 10D.29 | Motivation = visible competence progress + achievable next action + consistency. | Do not optimize learning for streak anxiety or session duration. |
| 10D.30 | Return after absence is low-friction. | No punitive reset; refresh evidence only when needed. |
| 10D.31 | Repeated skip = preference/friction signal; seek eligible alternatives. | Avoid interpreting avoidance as ability evidence. |
| 10D.32 | Repeated failure uses escalating recovery + stop rule. | Stop low-value struggle and change intervention when needed. |
| 10D.33 | Accessibility is a baseline constraint. | Usability/access should not be postponed as cosmetic polish. |
| 10D.34 | Learning accessibility may scaffold; readiness evidence must preserve construct or scope accommodation. | Support access without silently altering what a readiness claim means. |
| 10D.35 | Speaking permissions are just-in-time with clear upload/retention disclosure and local preview/retry. | Reduce privacy friction and surprise. |
| 10D.36 | Notifications are goal-supporting, user-controllable and relevant. | Notifications serve learning obligations, not compulsive engagement. |
| 10D.37 | Notification claims remain evidence-grounded. | Do not market stale evidence as deterioration. |
| 10D.38 | System failure → truthful degraded state + preserve accepted learner work + recovery. | Reliability UX must not fabricate progress or lose submissions. |
| 10D.39 | AI delay uses truthful coarse states + async continuation. | Do not invent fake processing stages. |
| 10D.40 | Experience succeeds when learner understands why/what/result/meaning/next without being misled. | Experience quality includes epistemic honesty. |

---


## 6.15 V10E — Cost Viability

| ID | Decision | Rationale |
| --- | --- | --- |
| 10E.1 | Cost considered only after eligibility/suitability/quality floors. | Price cannot rescue an invalid learning/evidence path. |
| 10E.2 | Measure cost at meaningful operational units where attribution is direct. | Use measurable run/path economics without pretending causal cost per band gain. |
| 10E.3 | Logical cost attribution by capability/action/run. | Provider invoices alone cannot identify costly product paths. |
| 10E.4 | Deterministic-first only when deterministic path satisfies required quality. | Cheap deterministic logic is good only when it solves the actual learning/evidence need. |
| 10E.5 | Use AI where semantic judgment or incremental value justifies it. | AI is a marginal-value tool, not default interaction tax. |
| 10E.6 | Expensive escalation only when uncertainty/risk/value justifies it. | Reserve stronger models for cases where they can change the outcome. |
| 10E.7 | Free and Premium share semantic truth + minimum quality/evidence floor. | Service depth may differ; truth model may not. |
| 10E.8 | Reusable validated core assets; runtime generation only when justified. | Pre-generation stabilizes rights/quality/cost and reproducibility. |
| 10E.9 | Personalize selection/feedback/fragments more than regenerating whole curriculum. | Most personalization value can come from routing and targeted feedback. |
| 10E.10 | Reuse/cache generic deterministic content when semantically and privacy-safe. | Avoid repeated generation of identical generic material. |
| 10E.11 | Bounded classified retry + idempotency + escalation. | Reliability and cost control require the same retry discipline. |
| 10E.12 | Same accepted submission uses same evaluation lineage unless explicit re-evaluation. | Prevent duplicate calls/charges and preserve provenance. |
| 10E.13 | Multiple operational budgets, not only a monthly company bill. | Control runaway requests/capabilities/providers without defining learning value by quota. |
| 10E.14 | Quota pressure preserves quality; reduce optional depth/volume/delay first. | Do not silently switch to inadequate scoring. |
| 10E.15 | Cost anomaly → observe + alert + bounded protective action/kill switch. | Runaway token/retry/provider anomalies need fast containment. |
| 10E.16 | Minimum sufficient model context. | Reduce cost/privacy exposure while keeping enough context for quality. |
| 10E.17 | Progressive explanation generation/disclosure. | Generate/retrieve deeper analysis only when useful. |
| 10E.18 | Speaking pipeline stages expensive analysis only where required. | Do not send every audio interaction through the most expensive model. |
| 10E.19 | Among semantically sufficient evidence strategies choose lower burden/cost. | Optimize after the evidence floor. |
| 10E.20 | Human review is exception/calibration/incident path, not default unit economics. | Commercial loop must scale without a human reviewer per attempt. |
| 10E.21 | Free retains a real learning loop with bounded expensive resources. | Free demonstrates product value while protecting sustainability. |
| 10E.22 | Premium = product-value entitlement + fair-use guardrails, not token packages. | Avoid becoming an AI quota storefront. |
| 10E.23 | Cost viability requires at least one quality-eligible reliable sustainable path under explicit assumptions. | Viability depends on entitlement/usage/scale/reliability, not the abstract path alone. |
| 10E.24 | If cost viability fails, do not support the target/path; redesign instead of lowering quality. | Economically impossible product paths are incomplete product coverage. |
---

---

# 7. V10F — Integrated Coverage / Asset Demand / Product-Support Declaration

**Authority:** `A1_FOUNDER_SELECTED_UNRECORDED`  
**Lifecycle:** `LOCKED / CLOSED_FOR_DESIGN`  
**Decision-phase effect:** `FINAL FOUNDER DECISION STAGE CLOSED`


| ID | Locked decision | Rationale |
| --- | --- | --- |
| 10F.1 | Coverage is evaluated against a versioned `TargetCoverageSpecification` scoped to a TargetProfile / requirement claim, not a band-wide scalar. | Makes every coverage judgment auditable and prevents one global “Band 7 coverage” number from hiding missing conditions. |
| 10F.2 | Integrated coverage uses logical condition composition (`required`, `alternative`, `supporting`; AND/OR as specified), never a weighted aggregate score. | A mandatory timed or transfer condition cannot be averaged away by strong coverage elsewhere. |
| 10F.3 | Every material coverage condition keeps its own status; minimum operational statuses are `UNKNOWN`, `DEFINED`, `PARTIAL`, `SATISFIED`, `BLOCKED`, `NOT_APPLICABLE`, and `CALIBRATION_REQUIRED`. | Allows precise blockers without inventing false percentages. Product-level MODELLED/COVERED/SUPPORTED/VALIDATED remain separate namespaces. |
| 10F.4 | Integrated coverage evaluates the material chain: requirement → competency/behaviour/context → intervention/learning path → evidence/re-evidence/transfer → experience/transition → cost viability, subject to rights/privacy/reliability quality gates. | Coverage must represent an executable learner path, not just curriculum inventory. |
| 10F.5 | A coverage hole is a product-level `CoverageGap`, never a learner `GapEvaluation`. | Prevents product defects from being misinterpreted as learner weakness. |
| 10F.6 | Each CoverageGap records scope, failed/missing condition, gap class, blocking consequence, dependencies, provenance/version, and required demand outputs; it does not require a numeric severity score. | Enough structure for planning/audit without fake precision. |
| 10F.7 | Coverage-gap classes may include model/spec, intervention/activity, content/asset, evidence/evaluator, experience, transition, cost/operations, rights/privacy/reliability, and calibration/validation; taxonomy is operational and may be refined without changing learner ontology. | Different holes require different fixes; not every problem is “make more content.” |
| 10F.8 | A coverage gap first derives a `DemandClass`; only appropriate gaps produce asset demand. | Prevents asset factories from becoming the universal answer to missing evaluator, UX, rights, reliability, or calibration capability. |
| 10F.9 | Demand derivation runs backward: CoverageGap → missing semantic capability → required activity/evidence/transition contract → demand class → asset/capability specification. | Keeps demand causally tied to a missing product path. |
| 10F.10 | For content demand, derive asset role, required contexts/variation, reuse constraints, novelty/transfer role, rights/provenance requirements, evaluator compatibility, and only then quantity. | Asset count becomes an output of semantic coverage requirements rather than a founder quota. |
| 10F.11 | Reuse an existing eligible asset/template/generator before creating a new asset when rights, quality, context, exposure/novelty, and evidence semantics permit. | Reduces cost and duplication without allowing overexposed material to masquerade as transfer evidence. |
| 10F.12 | Coverage symmetry means the same completeness standard across supported target profiles, not equal asset volume or equal difficulty distribution. | Different targets may need different quantities while still passing the same semantic coverage gate. |
| 10F.13 | `MODELLED → COVERED` only when the required semantic model is defined and every blocking integrated-coverage condition for the scoped target is satisfied; no blocking CoverageGap may remain. | Defines COVERED as a condition-satisfaction claim, not “lots of assets exist.” |
| 10F.14 | A `CALIBRATION_REQUIRED` condition blocks COVERED only when that calibration is necessary for the covered path/claim to operate truthfully; otherwise it remains a declared non-blocking validation backlog item. | Allows learning-path coverage before outcome validation while preventing uncalibrated scoring/readiness claims from slipping through. |
| 10F.15 | `COVERED → SUPPORTED_FOR_PRODUCT` requires an explicit versioned TargetSupportDeclaration plus all release-critical quality, rights, privacy/security, reliability, cost-viability, and claim-specific calibration gates required by that declaration. | Separates semantic path completeness from the decision to expose/support that target in the product. |
| 10F.16 | `SUPPORTED_FOR_PRODUCT → VALIDATED` requires scoped empirical evidence over the declared target/profile, learner population, product/evaluator/intervention versions, outcome, operating conditions, and evidence period. | Validation is an empirical claim with scope; it never follows from architectural coherence alone. |
| 10F.17 | Explicit support blockers include any unresolved mandatory construct/requirement ambiguity, missing required learning/intervention path, missing admissible independent/re-evidence/transfer path where required, experience dead-end, failed rights/privacy/security/reliability gate, non-viable operating path, or missing claim-critical calibration. | Makes “not supported” deterministic and reviewable rather than a discretionary product judgment. |
| 10F.18 | Product support is versioned and revocable: new quality, rights, provider, cost, calibration, or construct evidence may suspend/downgrade future support without rewriting historical declarations. | Support status must react to real regressions while preserving audit history. |
| 10F.19 | Validation backlog is separate from support blockers: a validation item is non-blocking only when the current product promise does not depend on that empirical claim; if the promise depends on it, the item becomes a blocking release gate. | Prevents both extremes: requiring outcome RCTs before any useful product, or marketing unvalidated claims as truth. |
| 10F.20 | 10F produces four operational outputs: Target Coverage Matrix, CoverageGap Register, Demand Register (asset and non-asset), and TargetSupportDeclaration/Validation Backlog; coverage summaries may report blocker/count metadata but never a single completeness percentage. | Creates the implementation bridge from model to work demand while preserving non-aggregate semantics. |

## 7.1 Resulting promotion semantics

```text
TargetCoverageSpecification
        ↓
logical condition evaluation
        ↓
no blocking CoverageGap
        ↓
COVERED
        ↓
TargetSupportDeclaration
+ release-critical quality/rights/privacy/reliability/cost gates
+ claim-critical calibration required by that declaration
        ↓
SUPPORTED_FOR_PRODUCT
        ↓
scoped empirical validation
        ↓
VALIDATED
```

## 7.2 10F outputs

Locked 10F semantics require four operational outputs:

1. Target Coverage Matrix;
2. CoverageGap Register;
3. Demand Register (asset and non-asset);
4. TargetSupportDeclaration + separate Validation Backlog.

Coverage summaries may report blocker/count metadata but never a single completeness percentage.

## 7.3 Decision-phase closure rule

```text
10A LOCKED
10B CLOSED
10C CLOSED
10D CLOSED
10E LOCKED
10F LOCKED
────────────
CURRENT FOUNDER DECISION PHASE CLOSED
```

Reopening requires material empirical evidence, a discovered contradiction, legal/regulatory change, or a governed founder decision—not implementation preference.

---

# 8. Source Supersession / Reconciliation Register

| Historical source baseline | Current founder-locked A1 decision | State | Reason |
|---|---|---|---|
| Next.js web + Go API + Python worker all on Cloud Run | Cloudflare Workers/OpenNext for Next.js; Cloud Run for API/workers | `PENDING_RECONCILIATION` | Edge-first frontend while retaining portable container backend. |
| Upstash required before first P0 async route | No Redis initially; Postgres outbox first | `PENDING_RECONCILIATION` | Avoid unnecessary early moving part; Redis remains non-authoritative. |
| Identity provider unselected | Auth0 selected | `PENDING_RECONCILIATION + ACTIVATION_BLOCKED` | Later founder selection supersedes historical unselected state. |
| Premium speaking path allowed durable recording | Server audio ephemeral-by-default unless separately approved later | `PENDING_RECONCILIATION` | Later privacy/product decision minimizes sensitive-data retention. |
| Cloudflare/R2/Neon/provider-neutral adapters | Retained | `ALIGNED` | Still matches portability/cost architecture. |
| PostHog-first / Sentry supplementary | Retained | `ALIGNED` | Still matches lean observability. |
| DeepSeek Flash/Pro route concept | Retained only as gated route architecture | `ALIGNED_WITH_GATES` | Route concept is not benchmark/procurement/quality approval. |

---

# 9. Open Items — Classified by What They Block

| ID | Block class | Open item | Owner | Why |
| --- | --- | --- | --- | --- |
| CANON-1 | BLOCK_CANONICALIZATION | Reconcile current A1 decisions against repository A0/A2 sources and record supersessions. | Founder + governance | Required before this register can be adopted as A0 canonical. |
| CANON-2 | BLOCK_CANONICALIZATION | Record canonical governance adoption reference for this frozen version. | Founder + governance | Founder sign-off is not repository governance adoption. |
| IMPL-1 | BLOCK_IMPLEMENTATION_SPEC | Write versioned TargetCoverageSpecification / CoverageGap / Demand / TargetSupportDeclaration schemas from locked 10F. | Product architecture + engineering | HOW/spec must follow locked WHAT. |
| IMPL-2 | BLOCK_IMPLEMENTATION_SPEC | Reconcile V7 provider ADRs before provider-specific implementation. | Founder + engineering | Avoid coding against superseded frontend/Redis/identity/audio source text. |
| IMPL-3 | BLOCK_IMPLEMENTATION_SPEC | Finalize content-rights admission workflow and machine-readable rights profile. | Product + privacy/legal + content ops | Needed for governed asset factory. |
| PROD-1 | BLOCK_PRODUCTION | Auth0 DPA/data-use/region/export/delete/session/rate-limit acceptance. | Privacy/legal + engineering/security | Provider selection ≠ activation. |
| PROD-2 | BLOCK_PRODUCTION | Postgres PITR/independent backup/restore verification/exit drill. | Engineering + ops | Backup existence ≠ recoverability. |
| PROD-3 | BLOCK_READINESS_CLAIM | Writing evaluator benchmark + claim-critical calibration + disagreement/failure tests. | Quality + engineering | AI route cannot create readiness evidence before calibration. |
| PROD-4 | BLOCK_PRODUCTION | Transactional email sender/auth/abuse/idempotency/fallback acceptance. | Engineering + ops | Required for account/reset flows. |
| PROD-5 | BLOCK_PRODUCTION | Observability privacy/redaction/retention/alert acceptance. | Product + privacy + ops | Raw learner content must remain outside generic telemetry. |
| PROD-6 | BLOCK_PRODUCTION | Emergency kill-switch/control-plane drill for risky paths. | Ops + engineering | Control must work under failing-subsystem conditions. |
| PROD-7 | BLOCK_PUBLIC_MINOR_USE | Minors/consent/privacy/legal policy review. | Founder + privacy/legal | Minor support changes legal/consent constraints. |
| CLAIM-1 | BLOCK_SPECIFIC_CLAIMS | Numeric readiness thresholds, sample counts, recency/consistency/transfer thresholds. | Quality/calibration | Remain empirical calibration, not founder ontology. |
| P1-1 | BLOCK_P1_SPEAKING | Speech retention reconciliation + STT/pronunciation/speaking benchmark/promotion gates. | Product + privacy + quality + engineering | P1 remains planned until evidence exists. |
| BUS-1 | BLOCK_PRICING_RELEASE | Free/Premium quotas, pricing and numeric cost ceilings. | Founder + product + ops | Exact economics require measured runtime data. |

There are **no open founder/product ontology decisions** in the current phase. Open work is execution, governance, evidence, legal/privacy, calibration, pricing or deferred P1 work.

---

# 10. Activation / Canonicalization Gate Sequence

Dates are not fabricated. The planning contract uses relative wave, dependency and state.

| Wave | Gate | Owner | Relative timing | Depends on | Done when | State |
| --- | --- | --- | --- | --- | --- | --- |
| W0-A | 10F.1–20 founder lock | Founder | DONE in this approval event | None | 10F moved to A1; decision phase closed. | DONE |
| W0-B | Freeze one-file v1.0.0 decision register | Product/governance artifact | DONE in this artifact | W0-A | Unique numbering, self-hash, final decision counts, source trace. | DONE |
| W0-C | Canonical repository reconciliation + A0 adoption | Founder + governance | NEXT / critical path | W0-B | Approved source supersessions + canonical adoption reference. | PENDING |
| W1-ID | Auth0 legal/data review | Privacy/legal | Parallel after W0-B; before auth activation | Auth0 selection | DPA/data use/region/subprocessors/deletion accepted. | PENDING |
| W1-DB | DB recovery configuration | Engineering + ops | Parallel after W0-B | Neon direction | PITR + independent logical backup configured. | PENDING |
| W1-AI | Evaluator benchmark/calibration preparation | Quality + engineering | Parallel after W0-B | AI architecture | Representative corpus, protocol, model/prompt/route version plan. | PENDING |
| W1-OBS | Telemetry privacy/event schema | Product + privacy + ops | Parallel after W0-B | V8 observability | Redaction/retention/consent/event contract. | PENDING |
| W1-EMAIL | Email domain/abuse controls | Engineering + ops | Parallel after W0-B | Identity flows | Sender auth + idempotency/rate-limit design. | PENDING |
| W1-KILL | Emergency-control implementation spec | Engineering + ops | Parallel after W0-C | V8.12 | Independent control-plane contract. | PENDING |
| W2-ID | Auth export/delete/token/session acceptance | Engineering + security/privacy | After W1-ID | W1-ID | Create/export/delete + issuer/audience/revocation/new-device OTP/rate-limit tests. | PENDING |
| W2-DB | Automated restore + external Postgres exit test | Engineering + ops | After W1-DB | W1-DB | App-level invariant restore + provider-exit evidence. | PENDING |
| W2-AI | Writing benchmark + cost/retry/disagreement acceptance | Quality + engineering + ops | After W1-AI | W1-AI | Claim-specific quality/calibration + route evidence. | PENDING |
| W2-OBS | Telemetry/alert acceptance | Product + privacy + ops | After W1-OBS | W1-OBS | No raw content; alerts/runbooks tested. | PENDING |
| W2-EMAIL | Deliverability/idempotency/fallback test | Engineering + ops | After W1-EMAIL | W1-EMAIL | Transactional auth/reset flow accepted. | PENDING |
| W2-KILL | Kill-switch failure drill | Engineering + ops | After W1-KILL | W1-KILL | Switch works while risky subsystem is impaired. | PENDING |
| W3-PILOT | End-to-end pilot release gate | Founder + product + engineering + ops + quality | After relevant W2 gates | W2-ID/DB/AI/OBS/EMAIL/KILL | Durability/auth/evaluation/recovery/monitoring/rollback pass together. | PENDING |
| W4-P1 | Speaking/audio activation lane | Product + privacy + quality + engineering | Separate later lane | Canonical + P1-specific privacy/benchmark gates | Does not block initial P0 path while Speaking remains P1. | PENDING |

## 10.1 Critical path

```text
DONE:  W0-A 10F founder lock
   ↓
DONE:  W0-B freeze one-file v1.0.0
   ↓
NEXT:  W0-C canonical source reconciliation + A0 adoption
   ↓
       W1 parallel implementation/acceptance preparation
   ↓
       W2 integration/quality/recovery acceptance
   ↓
       W3 end-to-end pilot release gate

W4 Speaking/audio remains a later P1 lane.
```

---

# 11. Product Support vs Individual Learner Readiness

## Product target status

```text
MODELLED
COVERED
SUPPORTED_FOR_PRODUCT
VALIDATED
```

## Individual learner readiness

```text
INSUFFICIENT_EVIDENCE
CONFLICTING_EVIDENCE
STALE_EVIDENCE
NOT_YET_SUPPORTED
SUPPORTED
```

A product target may be `SUPPORTED_FOR_PRODUCT` while an individual learner is `NOT_YET_SUPPORTED`.

A learner readiness `SUPPORTED` claim must be scoped to a product-supported target and current admissible evidence.

Neither status guarantees a future IELTS result.

---

# 12. Validation / Calibration Boundary

These are empirical work, not missing founder ontology:

- numeric evidence sufficiency thresholds;
- sample counts;
- recency/consistency windows;
- transfer thresholds;
- evaluator confidence/calibration;
- mastery update/forgetting coefficients;
- intervention efficacy by population/context/outcome/time horizon;
- outcome validation.

`VALIDATED` is always scoped and versioned.

A validation backlog item blocks `SUPPORTED_FOR_PRODUCT` only when the declared product promise depends on that unresolved empirical claim.

---

# 13. Provenance and Source Trace

## 13.1 Source manifest

| Artifact | Role | SHA-256 |
|---|---|---|
| `lenbands-decisions-20260812-123817.md` | Primary uploaded source export | `6c2b4244a30e6e5d3314c98a3d57cb81a8f1d0be648027b30d99a4bb721402ed` |
| `lenbands-decision-register-ssot-candidate-2026-08-12.md` | v0.1 predecessor, superseded | `3a714d096aa5445291256f083906a945f5c5e0abfbbae90360bf655cf27d2b90` |
| `lenbands-decision-register-v0.2.0-precanonical-2026-08-12.md` | v0.2 predecessor, superseded | `292ed80561db85e67788ed390021a4b5bc99b0dc7df5a2635687d336ccbd804c` |
| `lenbands-decision-register-v0.3.0-review-ready-2026-08-12.md` | v0.3 predecessor, superseded | `5be2a80d5ed6fa8dea0cde4db40e8c90fa41048f559278910209bab346cec233` |
| This v1.0.0 file | current founder-locked register | verify via `SELF_SHA256` scheme in Document Control |

Raw source is **not duplicated** into this register. The source is identified by exact filename + SHA-256 + line-range trace below.

## 13.2 Granular source trace

| Source lines | Historical evidence | Current decision families | Treatment |
| --- | --- | --- | --- |
| 21–36 | Identity/residency artifact declares itself a packet/review artifact, not a decision or evidence. | Governance; V3/V4/V7 | Retain as historical source; cannot be promoted to authority by consolidation. |
| 40–66 | Residency A/B/C options and trade-offs. | V1.1/V1.2; V7 region | Historical option analysis; later A1 direction selects no hard early VN residency and Singapore topology. |
| 70–108 | OIDC required contract and provider candidates. | V4; V7 Auth0 | Contract requirements retained; candidate list is historical. |
| 127–146 | Identity activation checklist. | Production gates | Converted into owner/dependency-aware activation gates. |
| 182–196 | Managed-platform baseline says founder-selected pre-code baseline; standards/provider-neutral core. | V1/V2/V7 | Baseline principle retained; not runtime readiness. |
| 198–214 | Provider baseline includes Cloudflare, Cloud Run, Neon, Upstash, email, PostHog, DeepSeek; identity unselected. | V5–V8; V7 | Explicit reconciliation recorded for frontend, Redis and Auth0. |
| 216–232 | Cost/experience/privacy policy: durable accepted work, truthful delay, Redis non-authority, no raw-content telemetry. | V2/V5/V6/V8/10E | Retained. |
| 234–247 | Capacity early-warning bands; numeric ceilings unarmed. | V8/10E | Historical operating guidance; numeric cost thresholds remain noncanonical. |
| 249–300 | Provider desk snapshot + DeepSeek risks/aliases/cache caveats. | V6/V7/10E | Historical snapshot only; reverify at procurement/benchmark time. |
| 302–312 | Provider activation/review gates. | Activation | Retained and sequenced by relative waves. |
| 379–397 | Phase 4 ledger explicitly review/proposal, no protected/runtime/readiness claims. | Governance | Negative authority boundary retained. |
| 399–430 | Phase 4 row statuses/dependencies/nonclaims. | Governance/V9/V10 provenance | Historical coordination evidence; later A1 decisions remain separate. |
| 432–451 | Packet handoff + literal proposal-only/no protected mutation boundary. | Governance | Retained. |
| 504–518 | Speaking P1/planned; no activated runtime/API/benchmark; browser transcript limitations. | V6/V9/10C/10D | P1/nonclaim boundary retained. |
| 522–533 | Browser transcript vs service transcription vs pronunciation evidence. | 10C | Retained as distinct evidence classes. |
| 535–545 | Progressive speech entitlement; older durable-premium recording wording. | V9/10D/10E | Entitlement concept retained; durable-recording wording superseded by later ephemeral-by-default A1 decision. |
| 547–569 | Provider-neutral speech adapter boundaries. | V6/V7 | Retained; named providers remain candidates until activation evidence. |
| 571–588 | Speech admission/recovery/idempotency/privacy rules. | V2/V3/V8/10D/10E | Retained. |
| 590–603 | Speech quality release ladder L0–L4. | Validation claims | Retained conceptually; no numeric speech claim before benchmark/calibration. |
| 604–624 | Speech privacy/accessibility rules. | V3/10D | Retained except recording retention reconciled to ephemeral-by-default. |
| 626–649 | Speech consequences and review triggers. | V6/10E/P1 gates | Retained as review rationale. |
| 700–722 | ADR template. | Canonicalization workflow | Structural template only; no authority. |
## 13.3 Provenance rule

A reviewer can verify a source claim by obtaining the named source artifact, confirming its SHA-256, and checking the cited line range.

If the file at that name does not match the recorded hash, it is not the source snapshot used for this register.

Conversation-derived V1–V10F decisions are founder decision evidence separate from the uploaded historical source. This file does not pretend those later decisions were already present in the older source export.

---

# 14. Integrity and Version Chain

## 14.1 One-file self-hash scheme

This register intentionally requires **no companion checksum file**.

Verification procedure:

1. Read this file as exact UTF-8 bytes.
2. On the line beginning `**SELF_SHA256:**`, replace the 64 hexadecimal characters with 64 ASCII zeroes.
3. SHA-256 hash the resulting full file bytes.
4. Compare with the displayed `SELF_SHA256`.

Any other content mutation changes the verification result.

## 14.2 Version chain

| Version | State | Main change |
|---|---|---|
| `0.1.0` | `SUPERSEDED` | First broad consolidation; weak formal integrity/governance structure. |
| `0.2.0` | `SUPERSEDED` | Added authority/lifecycle separation, provenance bundle concept, gate ownership. |
| `0.3.0` | `SUPERSEDED` | Added executive counts, dependency graph, glossary, single invariant source, 20 complete 10F proposals; review-ready but 10F not founder-locked. |
| `1.0.0` | `CURRENT / FOUNDER_LOCKED / PRE_CANONICAL` | Fixes unique numbering, locks 10F.1–20, closes decision phase, records founder approval event, consolidates provenance into one file, freezes self-hash. |

## 14.3 Signature boundary

The founder approval event in Section 2 is the recorded conversational sign-off for decision content.

There is **no fabricated cryptographic signature**. Cryptographic identity/signature may be added later only through a real signing mechanism.

A0 canonical adoption remains a separate governance event.

---

# 15. Canonicalization and Implementation Handoff

The decision phase is closed. The next sequence is:

```text
Founder-locked v1.0.0
        ↓
Repository source reconciliation
        ↓
A0 canonical governance adoption
        ↓
Regenerate affected projections
        ↓
Research / calibration / validation backlog
        ↓
Implementation specifications for approved WHAT
        ↓
Protected Claude Code / engineering HOW
```

Claude Code, implementation teams, runtime AI and asset factories may not reinterpret a closed WHAT decision merely for convenience.

If empirical evidence contradicts a locked decision, create a governed reopen record rather than silently changing semantics.

---

# 16. Final Status

```text
TOTAL FOUNDER-LOCKED DECISION ROWS:
325

10A:
LOCKED

10B:
CLOSED

10C:
CLOSED

10D:
CLOSED

10E:
LOCKED

10F:
LOCKED

CURRENT FOUNDER DECISION PHASE:
CLOSED

FOUNDER SIGN-OFF:
RECORDED — FOUNDER-CHAT-2026-08-12T16:05+07:00

CANONICAL REPOSITORY AUTHORITY:
PENDING A0 ADOPTION

IMPLEMENTATION AUTHORIZATION:
SEPARATE LATER WORKFLOW

VALIDATED EDUCATIONAL OUTCOMES:
NOT CLAIMED
```
