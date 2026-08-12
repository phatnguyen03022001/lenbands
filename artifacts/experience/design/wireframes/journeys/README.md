# Journeys

This branch divides wireframes by major learner journey. These are `experience journey` artifacts, not screen-level mockups.

Conventions:

- Each journey is a separate `.html` file.
- Each journey has a `.meta.yaml` for deep traceability to a Capability ID.
- `derived_from` always points to a `Capability ID` or `Experience section` in `04-experience.md`.
- Do not pack the full state matrix into each journey; keep state coverage in a separate artifact.

Suggested primary journeys:

- `first-day.html`
- `daily-learning.html`
- `deep-practice.html`
- `review-loop.html`
- `exam-readiness.html`

## Scope status

The closed pilot only needs First Day, Daily Learning, and Review Loop as design inputs. Deep Practice, Exam Readiness, Exam Day, After Exam, and Wrong Answer are product-horizon journeys; they must not be used to expand P0 scope. When the roadmap expands scope, each journey needs its own wireframe or a decision explaining why it is grouped into another artifact.
