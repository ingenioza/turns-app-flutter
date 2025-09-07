# COPILOT INSTRUCTIONS — TURNS (Flutter Mobile ONLY)

You are the execution engine for the **mobile client** in `turns-flutter/`.  
There is **no web client in Flutter**.

## Mission
Ship a production-ready MVP:
- Anonymous one-time sessions
- Persistent groups (history & fairness)
- Optional Auth (Firebase Auth: Google/Apple/email)
- Push notifications (FCM/APNs)
- Algorithms: random, round-robin, weighted
- **Full coverage** across unit, widget, golden, integration, and **Patrol E2E** (device)

## API Contract Discipline
- **turns-laravel is the single backend** for domain data (groups, participants, turns, history, notifications).
- Mobile uses Firebase Auth **only for identity**; exchange token with Laravel for API access.
- Keep a mirror at `docs/api-contract.md`; **authoritative** doc is `turns-laravel/docs/api-contract.md`.
- On mismatch: ask via **Cross-Repo Messaging**, open contract PR on Laravel, then sync DTOs/tests here.

## Context Hygiene
- Use `/docs/**` for requirements; update `/docs/checklists/*`, `/docs/plans/next-actions.md`, `/docs/progress.md` as behavior evolves.
- No silent drift between app behavior and docs.

## Cross-Repo Messaging Protocol (Flutter ↔ Laravel)
Use Markdown “mailboxes” for async coordination.

**Files in this repo**
- `sync/inbox.md`   — Messages from Backend to Mobile.
- `sync/outbox.md`  — Messages from Mobile to Backend.

**Mirroring (if repos are siblings under the same parent folder):**
- Also write a copy to: `../turns-laravel/sync/inbox.md` (create if missing).
- If sibling path not available, **note “Mirror pending”** at the top of your `sync/outbox.md`.

**Message Format (append to the bottom)**
```markdown
## SYNC MESSAGE
From: flutter
To: laravel
Type: API_READY | QUESTION | BLOCKER | CONTRACT_CHANGE | RELEASE_TAG
Relates: /docs/api-contract.md#<anchor> (if applicable)
Summary: <1–3 sentences>
Checklist:
- [x] App screens ready
- [x] DTOs updated
- [x] Integration tests adjusted
Artifacts:
- Branch/PR: <branch or #id>
- Commit: <sha>
- Tag: vX.Y.Z (if release)
Timestamp: 2025-09-07T00:00:00Z
```

**Agent loop requirements**
- At task start and before PR: **read** `sync/inbox.md`, process any items addressed “To: flutter.”
- When needing endpoints or clarifications: **write** to `sync/outbox.md` and mirror it.

## Architecture (Non-Negotiable)
- State: **BLoC** + **Repository**; DI with `get_it` (or Riverpod strictly for DI)
- Data flow: Repositories → DataSources (local + REST to Laravel)
- Storage: Hive/SharedPreferences (quick sessions, cache)
- Networking: **Dio**; DTOs explicit (`freezed` + `json_serializable`)
- Auth: Firebase Auth; device token registration; token exchange with Laravel
- Errors: sealed result types; never throw in Widgets
- Config: flavors (`dev`, `staging`, `prod`) for base URLs + Firebase options
- A11y: semantics labels, large text handling

## Testing (Non-Negotiable)
- **Unit**: domain, usecases, repositories (fakes)
- **Widget**: screen logic & transitions
- **Golden**: critical visuals via `golden_toolkit`
- **Integration**: repo ↔ datasource ↔ network (HTTP stub with `dio_http_mock_adapter`)
- **E2E (device)**: **`integration_test` + Patrol** (auth → create/join group → run turn across algorithms → history/fairness → notifications UI; includes offline/online recovery)
- **Notifications**: wrap Firebase Messaging; inject fakes for foreground/background

## CI Failure Handling (mandatory)
- After pushing, **wait for CI**. Do not continue while red.
- If CI fails:
  1) Copy the exact error summary into `/docs/progress.md` under **CI Failures**,
  2) Reproduce locally (`dart format`, `dart analyze`, `flutter test`, `flutter test integration_test`),
  3) Fix; extend tests if needed,
  4) Push; repeat until green.

---

## 🔄 Work Loop (after Phase 0, never skip)
1. **Select Task** → top unchecked item in active checklist  
2. **Branch** → `feature/<epic>-<short-task>` from `develop`  
3. **Plan** → `/docs/tasks/YYYYMMDD-<slug>.md` (Scope, AC, Touchpoints, Tests)  
4. **Implement** → small vertical slice (≤200 LOC or ≤10 files) **with unit + widget/golden + integration and, where applicable, Patrol E2E tests**  
5. **Validate** → `dart format`, `dart analyze` (strict), `flutter test` (all suites incl. integration/Patrol where applicable)  
6. **Commit** → Conventional commits, small chunks; push branch  
7. **Docs Update** → update `/docs/progress.md`; tick checklist item  
8. **PR** → to `develop` using template; **CI must be green**  
9. **Repeat** → after merge, pick next item  

---

## 🔒 Git Rules (must follow)
- Protected branches: **main**, **develop**  
- Branch names: `feature/...`, `fix/...`, `chore/...`  
- No giant commits; commit in slices  
- Conventional commits only  
- **Feature work**: from `develop` → PR to `develop`  
- **Bugfixes**: `fix/<issue>` → `develop`  
- **Chores**: `chore/<task>`  
- **Release**: merge approved `develop` → `main`, tag `vX.Y.Z`  
- **Hotfix**: branch from `main` → merge back into `main` + `develop`  
- **CI must pass** before merging any PR.

## Order of Execution
Follow `/docs/checklists/mvp-checklist.md`. For each step:
1) Read relevant `/docs` sections,  
2) Implement incrementally,  
3) Write/extend tests (**unit, widget, golden, integration, Patrol E2E** as appropriate),  
4) Run tests; commit,  
5) Update checklists and `/docs/plans/next-actions.md`.

## CI / Device Matrix (Gating)
- PR gating must run:
  - `dart format --set-exit-if-changed .`
  - `dart analyze --fatal-infos --fatal-warnings`
  - `flutter test` (unit + widget + golden)
  - `flutter test integration_test` (emulator/simulator)
- Nightly (optional): Patrol E2E smoke (quick session + create group + run random turn)
- Matrix: Ubuntu + Android emulator; macOS + iOS simulator

## Tooling Defaults (locked)
- DTOs: `freezed` + `json_serializable`
- HTTP stubbing: `dio_http_mock_adapter`
- E2E: `integration_test` + **Patrol**
- Flavors: `dev` / `staging` / `prod`
- Visual tests: `golden_toolkit` with device presets
