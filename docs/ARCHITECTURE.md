# Architecture

TimeTable follows a small, feature-oriented Flutter architecture with explicit boundaries between UI, state, persistence, and platform integrations.

## Data flow

```text
Screen / Widget
      │ user intent
      ▼
Provider (application state)
      │ read / write
      ▼
Service (Hive or native integration)
      │ persistence / platform channel
      ▼
Device storage or Android widget
```

Providers are the only layer that coordinates mutations. Widgets render provider state and send user intent back through provider methods. Services do not depend on UI code.

## Key components

- `PlanProvider` owns plan/category state, filtering, sorting, focus selection, and widget refreshes.
- `SettingsProvider` owns locale and theme preferences.
- `DatabaseService` initializes Hive and exposes persistence operations.
- `HomeWidgetService` maps active plans into the Android widget payload.
- `AppTheme` centralizes visual tokens and Material 3 component themes.
- `AppLocalizations` provides the current lightweight Turkish/English string catalog.

## Persistence

`Plan` and `Category` are Hive entities. Their `typeId` and field indexes are persisted API contracts: never reuse or renumber them after release. Regenerate adapters after changing annotated fields and commit the generated `*.g.dart` files.

## Platform boundaries

The core planner UI is portable. `HomeWidgetService` guards its Android-only behavior so web and desktop builds do not attempt native widget calls.

## Testing strategy

- Model tests cover defaults and immutable-style copy operations.
- Widget tests cover localization and theme behavior without native plugins.
- CI enforces formatting, analyzer cleanliness, and the full test suite.
