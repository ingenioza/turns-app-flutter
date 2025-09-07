# Testing Strategy — Flutter (Unit/Widget/Golden/Integration/Patrol)

## Tiers
1) **Unit** — Entities, use cases, repositories (with fakes)
2) **Widget** — Screens and components (happy/empty/error)
3) **Golden** — Visual baselines for critical screens
4) **Integration** — Repo ↔ datasource ↔ HTTP (mocked)
5) **E2E (Patrol)** — Full device flows

## Concrete Tests

### Unit
- Random/Round-robin/Weighted algorithm outputs
- Repositories: groups/participants/turns happy-path + failures
- Auth flow: token exchange request formatting

### Widget
- Add participants: validation and error display
- Algorithm picker: selection persists and drives action
- History view: renders latest entries; empty state

### Golden
- Result/announcement card
- Group list tile
- Algorithm picker modal

### Integration
- Dio client stubs for:
  - POST /auth/firebase/exchange
  - Groups list/create/update
  - Turns next + history

### E2E (Patrol)
- First-run anonymous quick session
- Sign-in (Google/Apple/email) happy + error states
- Create group → participants → run turn (all algorithms)
- History & fairness refreshed
- Notifications UI (fake messaging)
- Offline attempt → proper error → recover on reconnect

## Commands
- Format: `dart format --set-exit-if-changed .`
- Analyze: `dart analyze --fatal-infos --fatal-warnings`
- Unit/Widget/Golden: `flutter test`
- Integration: `flutter test integration_test`
- Patrol: `flutter test integration_test` (plus Patrol setup)
