# MVP Checklist

## Foundations
- [x] Repo bootstrap complete
- [x] CI green on base branch
- [x] Lint/format configured
- [ ] .env / secrets templated
- [x] Basic README updated

## Auth & Identity
- [ ] Anonymous session flow
- [ ] Firebase Auth (Google/Apple/email) wiring
- [ ] Device token registration

## Core Domain
- [x] Groups: create/join/leave (basic group support implemented)
- [x] Participants: add/remove/edit (full CRUD with UI)
- [x] Turn algorithms: random / round-robin / weighted (+ fairness algorithm)
- [x] History & fairness metrics (turn statistics implemented)
- [ ] Notifications fan-out

## Quality Gates
- [x] Unit tests implemented (basic structure)
- [ ] Integration tests implemented
- [ ] E2E/browser/Patrol (per repo) implemented
- [ ] Coverage thresholds met

## Docs & Ops
- [ ] API contract current
- [ ] Testing strategy current
- [x] Progress log updated
