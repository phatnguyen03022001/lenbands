# Technology Stack & Governance

This is the **Technology Decision Record** for LenBands' three layers: Go (`services/`), Python (`engines/`), and Next.js (`apps/`). It is not merely a library list—it defines the **policy for selecting, using, replacing, and retiring** technology.

All choices follow `ADR-0004` (composition-first) and `02-architecture.md` § Technology Stack.

---

## 1. Governance & Principles

### 1.1 Technology Selection Rules

1. **Capability-first, not library-first.** Select a library to implement a capability; do not select a capability based on a library.
2. **Stable over new.** Prefer a library with at least one major stable release, an active community, and clear maintainers.
3. **One primary, one alternative.** Each capability has exactly one primary recommendation and at most one clearly justified alternative.
4. **Provider behind an adapter.** External SDKs (Anthropic, Supabase, OpenAI) appear only behind the adapter boundary. Domain code works only with protocols/contracts.
5. **No framework bypass.** Domain code must not call an external service directly. Every external call must go through an adapter.

### 1.2 Version Policy

| Policy | Rule |
|---|---|
| Version target | Latest **stable** release (not beta, RC, or nightly) |
| Lock | Lockfile required (`go.sum`, `uv.lock`, `pnpm-lock.yaml`), committed |
| Upgrade cadence | Quarterly review (no auto-upgrade, no auto-major) |
| Compatibility window | Support two previous major versions before deprecation |
| Breaking change | Major version bump requires an ADR + migration plan + rollback path |
| Abandoned dependency | If no commit for six months → evaluate replacement |
| Security patch | Apply within seven days; no quarterly review required |

### 1.3 Technology Lifecycle

```text
adopt → hold → assess → replace → retire
```

| Phase | Meaning | Trigger |
|---|---|---|
| `adopt` | In use, active maintenance | — |
| `hold` | In use but no new use cases | An alternative is under evaluation |
| `assess` | Evaluate replacement | Exit criteria triggered |
| `replace` | Migrating to an alternative | ADR approved + migration plan |
| `retire` | No longer used, removed | Migration complete |

### 1.4 Exit Criteria Rule

Every capability in the matrix below must have **exit criteria**—conditions that trigger `assess → replace`. Without exit criteria, the technology decision is incomplete.

---

## 2. Capability Matrix

Organized by **capability**, not by library. Each row answers: what capability is needed → what is selected → why → when to replace it.

### 2.1 Frontend Capabilities (`apps/`)

| Capability | Primary | Phase | Why | Exit criteria |
|---|---|---|---|---|
| Web framework | Next.js 16 (App Router) | adopt | RSC, Server Actions, SSR/SSG, Vercel-native, React Compiler 1.0 | alternative reaches parity for RSC + Server Actions + routing |
| Language | TypeScript (strict) | adopt | Cross-layer type safety, industry standard | — |
| Styling | Tailwind CSS v4 | adopt | Utility-first, CSS-variable tokens, dark mode, RTL, tree-shaking | — |
| UI primitives | shadcn/ui + Radix | adopt | Ownership model, 50+ components, accessible, Tailwind-native | Base UI reaches parity |
| Server state | TanStack Query v5 | adopt | Caching, invalidation, optimistic update, devtools | — |
| Client state | Zustand v5 | adopt | Minimal, selector-based, persist middleware | Jotai or React context is sufficient |
| URL state | nuqs | adopt | Type-safe search params, App Router native | — |
| Forms | React Hook Form + Zod v4 | adopt | Uncontrolled inputs, Zod integration, shadcn/ui canonical | Conform reaches maturity |
| Animation | Motion | adopt | Delight moments, reduced-motion respect; current implementation is Framer Motion | framer-motion deprecated, or Motion has a sufficient ecosystem |
| Charts | Recharts | adopt | Declarative, composable, React-native | Nivo reaches parity + smaller bundle |
| Tables | TanStack Table v8 | adopt | Headless, sorting, filtering, pagination, virtualization | — |
| i18n | next-intl | adopt | App Router native, Server Components, ICU format | i18next reaches App Router parity |
| Theme | next-themes | adopt | Dark/light, SSR-safe | — |
| Toast | Sonner | adopt | Lightweight, async-friendly | — |
| Icons | Lucide React | adopt | 1,000+ icons, tree-shakeable | — |
| Linting/formatting | Biome | adopt | Rust-based, replaces ESLint+Prettier | — |
| Unit test | Vitest | adopt | Vite-native, Jest-compatible | — |
| Component test | Testing Library + MSW | adopt | User-centric, API mocking | — |
| E2E test | Playwright | adopt | Cross-browser, trace viewer, a11y assertions | — |
| Package manager | pnpm | adopt | Strict, fast, disk-efficient | — |
| Accessibility test | axe-core + Playwright a11y | adopt | WCAG AA, required for education product | — |
| Performance budget | Lighthouse CI | adopt | Core Web Vitals, bundle size, per-route budget | — |

### 2.2 Audio & Recording Capability

| Capability | Foundation | Implementation detail | Exit criteria |
|---|---|---|---|
| Audio playback | **wavesurfer.js** v7 | Canvas waveform, pre-computed peaks, speed control 0.75x–1.5x | browser Audio API provides sufficient waveform + speed control |
| Audio recording | **MediaRecorder** (browser native) | WAV/MP3 capture, live waveform (via wavesurfer.js) | browser API provides sufficient format options |
| Abstraction layer | Custom thin wrapper (≤200 LOC) | Do not depend directly on the wavesurfer.js API; the domain calls the `AudioPlayer` component | — |

**Principle:** IELTS is not a DAW. Simple audio playback/recording is required; multitrack, effects, and mixing are not. `wavesurfer.js` provides waveform rendering + decoding; `MediaRecorder` is a browser standard. A thin abstraction is sufficient.

### 2.3 Writing Editor Capability

| Decision | Status | Rule |
|---|---|---|
| Rich text vs plain text | **Not decided** | Requires a separate ADR; see "Technology Decisions NOT Yet Made" |
| If rich text | **TipTap** v3 (ProseMirror-based) | Extension system, custom word count + auto-save, collaboration via Yjs |
| If plain text + markdown | **textarea + custom word count + autosave** | ~100 LOC, no library required |
| Exit criteria | TipTap bundle size exceeds budget, or formatting is unused after three pilot months | Fallback: textarea + markdown render |

**Assessment:** For IELTS Writing Task 2, 90% of the need is textarea + word count + auto-save. TipTap is needed only for collaboration, rich formatting, or inline feedback annotation. This decision should be based on the Writing workspace wireframe.

### 2.4 Backend Capabilities (`services/` — Go)

| Capability | Primary | Phase | Why | Exit criteria |
|---|---|---|---|---|
| HTTP router | chi v5 | adopt | net/http compatible, middleware composable, GitLab production standard | Go ServeMux reaches route grouping + scoped middleware parity |
| RPC (internal) | Connect (Buf) | adopt | gRPC-compatible, first-class Go+TS | — |
| DB driver | pgx v5 | adopt | Native PostgreSQL, pgxpool, JSONB/ARRAY, fastest Go PG driver | — |
| Type-safe SQL | sqlc | adopt | Zero runtime reflection, 42.8k QPS, SQL reviewable | ent reaches performance parity + lower complexity |
| Migrations | golang-migrate | adopt | Simple, file-based, CLI + library | — |
| DB observability | sqlc-pgx-monitoring | adopt | OTel traces + metrics for sqlc+pgx | — |
| Redis client | **rueidis** | adopt | Redis Inc. maintained, auto-pipelining, Streams, Cluster, client-side caching, modern API | go-redis reaches Streams + pipelining parity |
| Job queue | **Redis Streams** (blueprint) | adopt | Per `02-architecture.md` § Queue/job P0; consumer groups, at-least-once | throughput > Redis Streams capacity, or multi-consumer complexity exceeds the threshold |
| OpenAPI codegen | oapi-codegen | adopt | Go types + server + client + validation from OpenAPI YAML | — |
| Validation | go-playground/validator | adopt | Struct tag, battle-tested | — |
| Auth provider | Supabase Auth (managed) | adopt-candidate | OIDC, MFA, Go SDK, per build/buy register | self-host requirement, or DPA/privacy conflict |
| JWT | go-jose (Square) | adopt | JWT/JWS/JWE/JWK, OIDC validation | — |
| Authorization | OpenFGA | adopt | Rebac, DSL permission model, Go-native | — |
| Structured logging | slog (stdlib) | adopt | Go native, JSON+text, attribute-based | Zap if zero-alloc is required (benchmark first) |
| Tracing | OpenTelemetry Go SDK | adopt | OTLP → Tempo, auto-instrumentation | — |
| Metrics | OTel + Prometheus | adopt | Counter, Histogram, Gauge | — |
| Error tracking | Sentry Go | adopt | Aggregation, breadcrumbs | — |
| CORS | rs/cors | adopt | net/http compatible | — |
| Security headers | secure (unrolled) | adopt | CSP, HSTS, X-Frame-Options | — |
| Test | testing (stdlib) + testify + testcontainers-go | adopt | Table-driven, real DB containers | — |

**Queue decision note:** The Blueprint selects Redis Streams for P0. River (Postgres-based) is an evaluated but unselected alternative—see "Technology Decisions NOT Yet Made". Changing the queue changes not only the library but also recovery, monitoring, retry, and deployment → a separate ADR is required.

### 2.5 Engine Capabilities (`engines/` — Python)

| Capability | Primary | Phase | Why | Exit criteria |
|---|---|---|---|---|
| Internal API | FastAPI | adopt | Async-first, Pydantic v2, largest AI ecosystem | Litestar reaches ecosystem + migration tooling parity |
| LLM structured output | Pydantic v2 + Instructor | adopt | Schema → LLM JSON mode, retry on parse failure | — |
| Prompt registry | Custom (YAML/JSON) | adopt | Versioned, hashed, validated; no external SaaS | — |
| LLM eval (CI gate) | DeepEval | adopt | Pytest-native, 14+ metrics, CI failing on threshold | — |
| LLM eval (red-team) | Promptfoo | adopt | 67 plugins, nightly, model comparison | — |
| LLM eval (custom) | Custom benchmark runner | adopt | Gold-standard corpus, examiner-labeled, per-rubric | — |
| Provider abstraction | EvaluationProvider protocol | adopt | Domain uses the protocol; Anthropic/OpenAI SDKs are in the adapter | — |
| Speech-to-text | OpenAI Whisper API (managed) | adopt-candidate | Per build/buy: managed initially | self-host cost/volume justified |
| Audio processing | pydub + ffmpeg-python | adopt | Conversion, trimming, normalization | — |
| Data processing | pandas + numpy | adopt | Analytics, cohort, retention metrics | Polars maturity reaches parity |
| Statistical testing | scipy | adopt | Significance, error recurrence, A/B testing | — |
| Package manager | uv (Astral) | adopt | 10-100x pip, lockfile, virtualenv | — |
| Linting/formatting | Ruff (Astral) | adopt | Rust-based, Flake8+isort+pyupgrade | — |
| Type checking | mypy (strict) | adopt | PEP-compatible, broad ecosystem | Pyright reaches CI integration parity |
| Test | pytest + pytest-asyncio | adopt | Async, fixtures, plugins | — |
| Coverage | coverage.py + pytest-cov | adopt | Branch coverage, reports | — |

---

## 3. AI Evaluation Boundary

This is a **critical boundary** for an AI-first product. LLM output must not go directly into the domain.

```text
┌─────────────────────────────────────────────────┐
│  DOMAIN LAYER                                    │
│  ┌───────────────────────────────────────────┐   │
│  │ EvaluationProvider (Protocol)             │   │
│  │   .evaluate(request) → EvaluationResult   │   │
│  └──────────────────┬────────────────────────┘   │
│                     │                             │
├─────────────────────┼─────────────────────────────┤
│  ADAPTER LAYER      │                             │
│  ┌──────────────────▼────────────────────────┐   │
│  │ AnthropicEvaluationProvider (Adapter)     │   │
│  │   - SDK call                              │   │
│  │   - retry/fallback                        │   │
│  └──────────────────┬────────────────────────┘   │
│                     │                             │
│  ┌──────────────────▼────────────────────────┐   │
│  │ Normalizer                                │   │
│  │   - extract structured fields             │   │
│  │   - map to rubric criteria (TR/CC/LR/GRA) │   │
│  └──────────────────┬────────────────────────┘   │
│                     │                             │
│  ┌──────────────────▼────────────────────────┐   │
│  │ Validator                                 │   │
│  │   - schema validation (Pydantic)          │   │
│  │   - rubric range check                    │   │
│  │   - confidence threshold                  │   │
│  │   - anti-gaming check                     │   │
│  └──────────────────┬────────────────────────┘   │
│                     │                             │
├─────────────────────┼─────────────────────────────┤
│  QUALITY GATE       │                             │
│  ┌──────────────────▼────────────────────────┐   │
│  │ Benchmark (DeepEval + Promptfoo)          │   │
│  │   - rubric alignment                      │   │
│  │   - drift detection                       │   │
│  │   - bias monitoring                       │   │
│  └──────────────────┬────────────────────────┘   │
│                     │                             │
│  ┌──────────────────▼────────────────────────┐   │
│  │ Domain Result (EvaluationResult)          │   │
│  │   - score, evidence, confidence, actions  │   │
│  │   - ready for learner-facing surface      │   │
│  └───────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

**Strictly prohibited:**

```
LLM → Domain Result   ← never permitted
```

Every LLM output must pass through: Adapter → Normalizer → Validator → Benchmark → Domain Result.

---

## 4. Prompt Registry Boundaries

Prompt Registry ≠ Prompt Engine.

| Registry (does) | Engine (does not) |
|---|---|
| Version + hash prompt template | Routing model by prompt |
| Metadata (rubric version, model target, owner) | Retry logic |
| Lineage (derived_from capability, framework refs) | Memory/context window management |
| Ownership (ai review, ai sign-off) | Orchestration pipeline |
| Validation (schema check, variable contract) | Rate limiting |
| Immutable audit (who changed, when, why) | Provider failover |

Implementation: YAML/JSON files in `artifacts/engineering/contracts/prompts/`, validated by CI. The prompt hash is referenced in the evaluation result for audit.

---

## 5. API Synchronization Strategy

**Status: PENDING ADR.** This is one of the most important decisions not yet settled.

| Approach | Flow | Pros | Cons |
|---|---|---|---|
| **OpenAPI-first** | OpenAPI YAML (SSOT) → generate Go types + TS types + Python validation | Single source, machine-verifiable, CI-enforced | Requires discipline; the OpenAPI spec must be complete |
| **Code-first** | Go/Python code → generate OpenAPI → generate TS | Natural dev flow; code is the SSOT | Drift risk; code annotations can be wrong |

**Recommendation:** OpenAPI-first. LenBands already has OpenAPI contracts in `artifacts/engineering/contracts/`. The contract is the SSOT; code is the implementation. CI verifies: OpenAPI YAML → generate → check no diff.

**Exit criteria for changing it:** OpenAPI spec complexity exceeds maintainability, or team velocity is blocked by the spec-first workflow.

---

## 6. Cross-Cutting Capabilities

### 6.1 Infrastructure

| Capability | Primary | Phase | Exit criteria |
|---|---|---|---|
| Database | PostgreSQL 17 (managed) | adopt-candidate | Postgres does not meet search/vector needs at scale |
| Cache / Queue / Rate limit | Redis (managed) | adopt-candidate | Redis Streams lacks sufficient throughput → evaluate Kafka |
| Object storage | S3-compatible (managed) | adopt-candidate | vendor lock-in, or cost exceeds budget |
| CI/CD | GitHub Actions | adopt | repository migration, or build time exceeds the threshold |
| Container registry | ghcr.io | adopt | — |
| IaC | Optional (Terraform if needed) | hold | P0 managed services may not need IaC |

### 6.2 Observability (Cross-Stack)

| Stack | Tracing | Metrics | Logging | Error Tracking |
|---|---|---|---|---|
| Go | OTel Go SDK (OTLP → Tempo) | OTel + Prometheus | slog (JSON → Loki) | Sentry Go |
| Python | OTel Python SDK (auto-instrument) | OTel + Prometheus | structlog (JSON → Loki) | Sentry Python |
| Next.js | OTel JS (edge + server) | OTel + Prometheus | pino (JSON → Loki) | Sentry Next.js |
| Dashboard | — | **Grafana** | — | — |

### 6.3 Security & Supply Chain

| Capability | Primary | Phase | Why |
|---|---|---|---|
| Dependency scanning | **Dependabot** / Renovate | adopt | Auto-PR for vulns, quarterly grouping |
| SBOM generation | **Syft** | adopt | Software Bill of Materials, compliance |
| Vulnerability scanning | **Grype** | adopt | CVE database, CI gate on critical/high |
| Secret scanning | **Gitleaks** | adopt | Pre-commit hook + CI gate, no secrets in repo |
| License compliance | **FOSSA** / Trivy | adopt | License inventory, copyleft detection |
| Container scanning | **Trivy** | adopt | Container image CVE scan in CI |

### 6.4 Contract & Load Testing

| Capability | Primary | Phase | Why |
|---|---|---|---|
| API contract test | **Schemathesis** | adopt | Property-based OpenAPI test, auto-generates cases |
| Load test | **k6** (Grafana) | hold (P1) | JavaScript test scripts, CI integration; activate when runtime exists |
| Performance budget | **Lighthouse CI** | adopt | Per-route Core Web Vitals, bundle size, blocking time |

---

## 7. Technology Decisions NOT Yet Made

These decisions remain open—clearly distinguish **decided**, **under evaluation**, and **not decided**.

| # | Decision | Status | Options | Blocker | Expected resolution |
|---|---|---|---|---|---|
| D1 | Rich text vs plain text editor | Evaluating | TipTap vs textarea+markdown | Writing workspace wireframe complete | Before P0-04 code |
| D2 | Redis Streams vs River (Postgres) | Decided (Redis Streams) | River is an alternative with an ADR if needed | Blueprint selects Redis Streams; reopen if throughput/complexity exceeds the threshold | P0 go-live review |
| D3 | Realtime: WebSocket vs SSE | Not started | WS for Speaking, SSE for evaluation status | No Speaking P0 yet; evaluation status uses P0 polling | Before P1 Speaking |
| D4 | Object storage: S3 vs R2 | Not started | AWS S3 vs Cloudflare R2 | Cloud provider not selected | Before P0-01 code |
| D5 | Search: Postgres FTS vs Meilisearch | Decided (Postgres FTS P0) | Meilisearch when the catalog scales | Per blueprint: Postgres FTS first | P1 review |
| D6 | Redis vs Kafka | Decided (Redis P0) | Kafka deferred per blueprint | Throughput/retention/multi-consumer needs exceed Redis Streams | P1 review |
| D7 | Cloud provider | Not started | Vercel (FE) + Railway/Render/Fly (BE) + managed DB/Redis | No procurement yet | Before P0-01 code |
| D8 | CI/CD platform: GitHub Actions vs alternative | Decided (GitHub Actions) | — | — | — |
| D9 | OpenAPI-first vs code-first | Evaluating | Recommendation: OpenAPI-first | Requires founder approval | Before any API code |
| D10 | Monorepo vs multi-repo | Not started | Turborepo vs separate repos | No code yet | Before scaffold |
| D11 | Go internal RPC: Connect vs gRPC-gateway | Decided (Connect) | — | — | — |
| D12 | Queue worker: same Redis Streams (Go+Python) vs separate queues | Decided (shared Redis Streams) | Python worker consumes Go-enqueued Streams | Per blueprint: one queue, cross-language consumer groups | — |

---

## 8. What NOT to Use

| Library | Reason | Note |
|---|---|---|
| **GORM** (Go ORM) | Heavy reflection, implicit N+1, magic behavior | Use sqlc |
| **Django** (Python) | Full-stack framework, opinionated ORM | Use FastAPI |
| **Fiber** (Go) | fasthttp is not compatible with net/http | Use chi |
| **Styled Components / CSS-in-JS** | Not compatible with RSC | Use Tailwind v4 |
| **Redux Toolkit** | Overkill for LenBands | Use Zustand + TanStack Query |
| **Formik / React Final Form** | Unmaintained | Use React Hook Form |
| **Celery** (Python) | Too heavy for P0 | Use Redis Streams consumer |
| **LangChain / LangGraph** | Not in the core domain. May be used for prototypes/tooling. Do not put it on the production path or foundation. | A simple prompt registry is better |

---

## 9. Security & Governance Rules

1. **No framework bypass.** Every external service call must go through an adapter. Do not code `curl Anthropic` directly in the domain.
2. **No raw output to learner.** Every LLM output must pass through Normalizer → Validator → Benchmark before reaching the learner.
3. **No secrets in repo.** Gitleaks pre-commit hook + CI gate. Every credential goes through an environment variable or secret manager.
4. **No PII in logs.** Raw essay, audio, and provider payloads must not enter observability/analytics.
5. **Lockfile committed.** `go.sum`, `uv.lock`, and `pnpm-lock.yaml` must be committed and reviewed.
6. **SBOM on release.** Each release creates an SBOM (Syft) + vulnerability scan (Grype).
7. **Dependency update policy.** Security patches within seven days; non-security updates quarterly; major versions require an ADR.
8. **Container scanning.** Every Docker image must pass a Trivy scan before push.

---

## 10. P0 Scaffold Checklist

### Go (`services/`)
```text
☐ go.mod (latest stable Go)
☐ go.sum (committed)
☐ Chi router + middleware chain (RequestID → Logger → Recoverer → CORS → Secure → Auth)
☐ pgx/v5 + sqlc config (sqlc.yaml)
☐ golang-migrate migrations/
☐ rueidis Redis client
☐ Redis Streams consumer group (Go → Python job boundary)
☐ oapi-codegen generated/ from OpenAPI specs
☐ OpenTelemetry + slog setup
☐ Sentry Go
☐ Gitleaks pre-commit hook
☐ Dockerfile (multi-stage) + Trivy scan
```

### Python (`engines/`)
```text
☐ pyproject.toml (Python latest stable)
☐ uv.lock (committed)
☐ FastAPI app skeleton
☐ EvaluationProvider protocol + Anthropic adapter + Normalizer + Validator
☐ Prompt registry (YAML/JSON, versioned + hashed)
☐ DeepEval conftest.py (CI gate) + Promptfoo config (nightly)
☐ Custom benchmark runner (gold-standard corpus)
☐ Redis Streams consumer (receives jobs from Go)
☐ OpenTelemetry + structlog setup
☐ Sentry Python
☐ Dockerfile (multi-stage) + Trivy scan
```

### Next.js (`apps/`)
```text
☐ package.json (Next.js 16 + React 19)
☐ pnpm-lock.yaml (committed)
☐ Tailwind v4 config
☐ shadcn/ui components (copied, not installed)
☐ TanStack Query provider + Zustand store(s)
☐ next-intl config (vi + en)
☐ Writing editor (TipTap or textarea — per ADR)
☐ Audio player (wavesurfer.js thin wrapper) + MediaRecorder
☐ Recharts + TanStack Table (Dashboard)
☐ axe-core + Playwright a11y assertions
☐ Lighthouse CI (performance budget)
☐ Gitleaks pre-commit hook
☐ Dockerfile (multi-stage) + Trivy scan
```

---

## References

**Internal:**
- `blueprint/02-architecture.md` — Technology Stack, system boundary
- `blueprint/06-engines.md` — Engine contracts, failure, governance
- `artifacts/engineering/decisions/ADR-0004-composition-first-application-platform.md` — composition-first policy
- `artifacts/business/decisions/build-buy-register.md` — build/buy baseline

**External:**
- Chi: <https://github.com/go-chi/chi>
- sqlc: <https://sqlc.dev>
- rueidis: <https://github.com/redis/rueidis>
- shadcn/ui: <https://ui.shadcn.com>
- TanStack Query: <https://tanstack.com/query>
- Motion: <https://motion.dev>
- wavesurfer.js: <https://wavesurfer.js.org>
- DeepEval: <https://github.com/confident-ai/deepeval>
- Promptfoo: <https://www.promptfoo.dev>
- FastAPI: <https://fastapi.tiangolo.com>
- Schemathesis: <https://github.com/schemathesis/schemathesis>
- Syft: <https://github.com/anchore/syft>
- Grype: <https://github.com/anchore/grype>
- Gitleaks: <https://github.com/gitleaks/gitleaks>
- k6: <https://grafana.com/docs/k6>
