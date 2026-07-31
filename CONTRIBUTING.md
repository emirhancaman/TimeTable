# Contributing

Thanks for helping improve TimeTable. Small, focused changes with a clear reason are easiest to review.

## Development setup

1. Install Flutter 3.38 or newer.
2. Fork and clone the repository.
3. Run `flutter pub get`.
4. Start the app with `flutter run`.

## Workflow

1. Create a branch from `main` (`feature/...`, `fix/...`, or `docs/...`).
2. Keep unrelated changes out of the same pull request.
3. Add or update tests for behavior changes.
4. Run the quality checks below.
5. Open a pull request using the repository template.

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
```

If an annotated Hive model changes, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit generated Hive adapters with the model change.

## Commit messages

Use concise, imperative messages. Conventional prefixes are encouraged:

- `feat:` user-facing capability
- `fix:` bug fix
- `refactor:` internal change without behavior change
- `test:` test-only change
- `docs:` documentation-only change
- `chore:` tooling or maintenance

## Pull requests

Explain the problem, the chosen solution, and how it was verified. Include screenshots or a short recording for visible UI changes. Keep generated build output and local logs out of commits.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
