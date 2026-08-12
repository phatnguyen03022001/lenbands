# Capability Phase Index (projection)

Metadata canonical ở sibling `capability-phase-index.meta.yaml`.

- `generated_from`: `blueprint/03-features.md` + `blueprint/08-roadmap.md`
- `generated_at`: `2026-08-07` (manual projection; generator chưa có)
- `schema_version`: `1`

Đây là registry phasing để không nhầm capability catalog với active scope. Nguồn identity là `blueprint/03-features.md`; nguồn delivery decision là `blueprint/08-roadmap.md`. Capability không có trong P0/P1/P2 candidate hiện tại được đánh dấu `deferred`, không được suy ra là build-ready.

| Capability ID | First planned phase | Interpretation |
|---|---|---|
| `ADMIN.AccountStatus` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.AuditLog` | P2 | candidate only; no active build scope |
| `ADMIN.Billing` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.Dashboard` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.GovernanceDashboard` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.ModerationLog` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.Permission` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.Premium` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.Revenue` | P2 | candidate only; no active build scope |
| `ADMIN.Role` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.SystemSetting` | deferred | Blueprint identity only; no active phase assigned |
| `ADMIN.User` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.Checklist` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.Completion` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.Current` | P0 | closed pilot profile; readiness still evidence-gated |
| `BAND.Descriptor` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.ExamReadiness` | P1 | candidate after P0 evidence; not active build scope |
| `BAND.Map` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.ProgressionWarning` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.Readiness` | P1 | candidate after P0 evidence; not active build scope |
| `BAND.RecommendedNext` | P1 | candidate after P0 evidence; not active build scope |
| `BAND.Requirement` | deferred | Blueprint identity only; no active phase assigned |
| `BAND.Target` | deferred | Blueprint identity only; no active phase assigned |
| `COACH.AnswerExplanation` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.DistractorExplanation` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.ErrorAnalysis` | P0 | closed pilot profile; readiness still evidence-gated |
| `COACH.Feedback` | P0 | closed pilot profile; readiness still evidence-gated |
| `COACH.ListeningCoach` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.ReadingCoach` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.Recommendation` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.Tutor` | P1 | candidate after P0 evidence; not active build scope |
| `COACH.VocabularyExplanation` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.AutoTag` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.BlueprintUpdate` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Feedback` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Knowledge` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Lesson` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.MockTest` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Moderation` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Publish` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.QuestionBank` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Quiz` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.Tag` | P1 | candidate after P0 evidence; not active build scope |
| `CONTENT.TagReview` | P1 | candidate after P0 evidence; not active build scope |
| `EVAL.AntiGaming` | deferred | deprecated alias; implementation owner is `GOVERNANCE.AntiGaming` |
| `EVAL.BandPrediction` | deferred | Blueprint identity only; no active phase assigned |
| `EVAL.Examiner` | P1 | candidate after P0 evidence; not active build scope |
| `EVAL.Pronunciation` | P1 | candidate after P0 evidence; not active build scope |
| `EVAL.RewriteSuggestion` | P1 | candidate after P0 evidence; not active build scope |
| `EVAL.Speaking` | P1 | candidate after P0 evidence; not active build scope |
| `EVAL.Writing` | P0 | closed pilot profile; readiness still evidence-gated |
| `GOAL.Daily` | deferred | Blueprint identity only; no active phase assigned |
| `GOAL.ExamPlan` | P2 | candidate only; no active build scope |
| `GOAL.StudyPlan` | deferred | Blueprint identity only; no active phase assigned |
| `GOAL.Target` | P0 | closed pilot profile; readiness still evidence-gated |
| `GOAL.Weekly` | deferred | Blueprint identity only; no active phase assigned |
| `GOVERNANCE.AntiGaming` | P1 | candidate after P0 evidence; not active build scope |
| `GOVERNANCE.AuditTrail` | P0 | closed pilot profile; readiness still evidence-gated |
| `GOVERNANCE.BiasMonitoring` | P1 | candidate after P0 evidence; not active build scope |
| `GOVERNANCE.ConfidenceScore` | P0 | closed pilot profile; readiness still evidence-gated |
| `GOVERNANCE.Dashboard` | P1 | candidate after P0 evidence; not active build scope |
| `GOVERNANCE.DriftDetection` | P1 | candidate after P0 evidence; not active build scope |
| `GOVERNANCE.GoldStandardBenchmark` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.Attempts` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.BandTimeline` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.Compare` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.LearningTimeline` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.ScoreTimeline` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.SkillTimeline` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.SpeakingPortfolio` | P1 | candidate after P0 evidence; not active build scope |
| `HISTORY.WritingPortfolio` | P1 | candidate after P0 evidence; not active build scope |
| `IDENTITY.Auth` | P0 | closed pilot profile; readiness still evidence-gated |
| `IDENTITY.DeleteAccount` | deferred | Blueprint identity only; no active phase assigned |
| `IDENTITY.Privacy` | P0 | closed pilot profile; readiness still evidence-gated |
| `IDENTITY.Profile` | P0 | closed pilot profile; readiness still evidence-gated |
| `IDENTITY.Recovery` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Collocation` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Example` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Exercise` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Grammar` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Lesson` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Strategy` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Template` | deferred | Blueprint identity only; no active phase assigned |
| `KA.Vocabulary` | deferred | Blueprint identity only; no active phase assigned |
| `LEARN.Listening` | P1 | candidate after P0 evidence; not active build scope |
| `LEARN.Path` | deferred | Blueprint identity only; no active phase assigned |
| `LEARN.Pronunciation` | P1 | candidate after P0 evidence; not active build scope |
| `LEARN.QuestionTypes` | deferred | Blueprint identity only; no active phase assigned |
| `LEARN.Reading` | P1 | candidate after P0 evidence; not active build scope |
| `LEARN.Speaking` | P1 | candidate after P0 evidence; not active build scope |
| `LEARN.Writing` | P0 | closed pilot profile; readiness still evidence-gated |
| `LOC.AIResponseLanguage` | deferred | Blueprint identity only; no active phase assigned |
| `LOC.InterfaceLanguage` | deferred | Blueprint identity only; no active phase assigned |
| `LOC.LocaleFormat` | P2 | candidate only; no active build scope |
| `LOC.PreferenceSync` | deferred | Blueprint identity only; no active phase assigned |
| `LOC.Switcher` | deferred | Blueprint identity only; no active phase assigned |
| `NOTIF.Goal` | P2 | candidate only; no active build scope |
| `NOTIF.Preference` | P1 | candidate after P0 evidence; not active build scope |
| `NOTIF.QuietHours` | P1 | candidate after P0 evidence; not active build scope |
| `NOTIF.Reengagement` | P1 | candidate after P0 evidence; not active build scope |
| `NOTIF.Result` | P2 | candidate only; no active build scope |
| `NOTIF.Review` | P2 | candidate only; no active build scope |
| `NOTIF.SRS` | P2 | candidate only; no active build scope |
| `NOTIF.SmartDelivery` | P1 | candidate after P0 evidence; not active build scope |
| `NOTIF.Study` | P2 | candidate only; no active build scope |
| `OPS.ContentQuality` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.CostBudget` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.EvaluationQuality` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.ModelRouting` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.Observability` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.OutcomeMeasurement` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.Quota` | P0 | closed pilot profile; readiness still evidence-gated |
| `OPS.ReleaseGate` | P0 | closed pilot profile; readiness still evidence-gated |
| `PERSONAL.AdaptivePlan` | P2 | candidate only; no active build scope |
| `PERSONAL.GapAnalysis` | P1 | candidate after P0 evidence; not active build scope |
| `PERSONAL.GoalRecommendation` | deferred | Blueprint identity only; no active phase assigned |
| `PERSONAL.Insights` | P1 | candidate after P0 evidence; not active build scope |
| `PERSONAL.NextBestAction` | P0 | closed pilot profile; readiness still evidence-gated |
| `PERSONAL.Recommendation` | P1 | candidate after P0 evidence; not active build scope |
| `PERSONAL.WeaknessPractice` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Collections` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Drafts` | P0 | closed pilot profile; readiness still evidence-gated |
| `PKM.Export` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Import` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Notes` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Offline` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Recordings` | deferred | Blueprint identity only; no active phase assigned |
| `PKM.SavedItems` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.Sync` | P1 | candidate after P0 evidence; not active build scope |
| `PKM.WordBank` | P1 | candidate after P0 evidence; not active build scope |
| `PLACE.BandEstimation` | P0 | closed pilot profile; readiness still evidence-gated |
| `PLACE.GapDetection` | P0 | closed pilot profile; readiness still evidence-gated |
| `PLACE.InitialPath` | P0 | closed pilot profile; readiness still evidence-gated |
| `PLACE.SkillDiagnosis` | P0 | closed pilot profile; readiness still evidence-gated |
| `PLACE.Test` | P0 | closed pilot profile; readiness still evidence-gated |
| `PRACTICE.Adaptive` | P1 | candidate after P0 evidence; not active build scope |
| `PRACTICE.Drill` | P0 | closed pilot profile; readiness still evidence-gated |
| `PRACTICE.ExamSimulation` | P1 | candidate after P0 evidence; not active build scope |
| `PRACTICE.MockTest` | P1 | candidate after P0 evidence; not active build scope |
| `PRACTICE.Set` | P1 | candidate after P0 evidence; not active build scope |
| `PRACTICE.Timed` | P1 | candidate after P0 evidence; not active build scope |
| `PROGRESS.Achievement` | P1 | candidate after P0 evidence; not active build scope |
| `PROGRESS.BandProgress` | deferred | Blueprint identity only; no active phase assigned |
| `PROGRESS.Dashboard` | deferred | Blueprint identity only; no active phase assigned |
| `PROGRESS.GoalTracking` | deferred | Blueprint identity only; no active phase assigned |
| `PROGRESS.LearningAnalytics` | P2 | candidate only; no active build scope |
| `PROGRESS.Motivation` | P1 | candidate after P0 evidence; not active build scope |
| `PROGRESS.Reactivation` | P1 | candidate after P0 evidence; not active build scope |
| `PROGRESS.SkillAnalytics` | P2 | candidate only; no active build scope |
| `PROGRESS.WeeklyRecap` | deferred | Blueprint identity only; no active phase assigned |
| `PROGRESS.Wellbeing` | P1 | candidate after P0 evidence; not active build scope |
| `REVIEW.Bookmark` | deferred | Blueprint identity only; no active phase assigned |
| `REVIEW.FSRS` | P0 | closed pilot profile; readiness still evidence-gated |
| `REVIEW.History` | deferred | Blueprint identity only; no active phase assigned |
| `REVIEW.MistakeNotebook` | P0 | closed pilot profile; readiness still evidence-gated |
| `REVIEW.QuestionReview` | deferred | Blueprint identity only; no active phase assigned |
| `REVIEW.Queue` | deferred | Blueprint identity only; no active phase assigned |
| `REVIEW.SmartQueue` | P0 | closed pilot profile; readiness still evidence-gated |
| `REVIEW.WrongAnswer` | deferred | Blueprint identity only; no active phase assigned |
| `REVIEW.WrongQuestion` | deferred | Blueprint identity only; no active phase assigned |
| `SEARCH.BandDescriptor` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.Cheatsheet` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.Formula` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.Global` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.Knowledge` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.Question` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.SpeakingSample` | P1 | candidate after P0 evidence; not active build scope |
| `SEARCH.WritingSample` | P1 | candidate after P0 evidence; not active build scope |
| `STUDY.CheckIn` | P0 | closed pilot profile; readiness still evidence-gated |
| `STUDY.Continue` | P1 | candidate after P0 evidence; not active build scope |
| `STUDY.DailyPlan` | P0 | closed pilot profile; readiness still evidence-gated |
| `STUDY.MicroSession` | P0 | closed pilot profile; readiness still evidence-gated |
| `STUDY.Resume` | P1 | candidate after P0 evidence; not active build scope |
| `STUDY.Session` | P1 | candidate after P0 evidence; not active build scope |
| `STUDY.SessionSummary` | P1 | candidate after P0 evidence; not active build scope |
| `STUDY.TodayQueue` | deferred | Blueprint identity only; no active phase assigned |
| `SUB.Payment` | P1 | candidate after P0 evidence; not active build scope |
| `SUB.Plan` | P1 | candidate after P0 evidence; not active build scope |
| `SUB.Premium` | P1 | candidate after P0 evidence; not active build scope |
| `SUB.UsageLimit` | P1 | candidate after P0 evidence; not active build scope |

## Rules

- `P0` chỉ là closed-pilot scope; Build Readiness Matrix và evidence gate vẫn quyết định có thể build/launch hay chưa.
- `P1` và `P2` là horizon planning, không phải approval, contract readiness hay evidence.
- `deferred` giữ identity trong Blueprint nhưng không được kéo vào P0 bằng copy/paste; muốn nâng scope phải có decision và evidence.
- Projection này phải được regenerate khi capability catalog hoặc roadmap thay đổi.

## References

- [Capability catalog](../../../blueprint/03-features.md)
- [Roadmap](../../../blueprint/08-roadmap.md)
