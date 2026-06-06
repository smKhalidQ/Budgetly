# Flutter AI Agent Rules
> Stack: Flutter · Clean Architecture · Cubit · Freezed · GetIt

---

## 1. General Rules

- Don't add any method or code that won't be used. Remove unused fields, merge fields if possible, keep only what's necessary.
- Avoid `dynamic` unless the type is genuinely unknown at compile time (e.g. JSON parsing entry point). If the type is known, use it explicitly. In JSON parsing, use `Map<String, dynamic>` — never a bare `dynamic`.
- Don't split a method into two just to wrap a single call — if a method only checks a condition and delegates to another, inline the guard instead.
- Avoid over-engineering by default — only add abstraction when it solves a real, current problem in the code, not a hypothetical one. Exception: if the complexity is critical (security, data integrity, shared across multiple features), abstraction is justified even early.
- Pass only what a widget or function actually needs — not the entire state or model. If a widget uses 2 fields out of 15, pass those 2 fields directly. Exception: if the widget uses more than ~70% of an object's fields, pass the whole object.
- Before creating any new model, type, or utility — search the codebase first. If a model like `Money` or `Address` already exists, reuse it or extend it. Never duplicate a concept that already has a representation in the project.
- Do not auto-fix or auto-run developer tooling. Never remove unused imports, never run `flutter pub get`, `dart pub run build_runner build --delete-conflicting-outputs`, or any similar commands. Never auto-format, auto-sort, or auto-clean code. Leave it to the developer or do it only when explicitly asked.

---

## 2. Architecture & Layer Rules

- Screen handles UI interactions (navigation, dialogs, pickers) — no business or data logic.
- All logic goes in the Cubit or domain layer.
- Use Cubit for state management; simple coordination logic may live inside it.
- If logic is complex or shared across features, create a service in the domain layer.
- No abstract interfaces for repositories unless multiple real implementations exist.
- No use cases — repositories handle composition of multiple API calls.

---

## 3. Data Layer

- Every API response becomes a `@freezed` sealed class named `ApiXxx` with `fromJson`.
- `toDomain()` lives as an extension on the same `ApiXxx` file — not a separate class.
- Data sources are for local storage only (SharedPrefs, Hive, etc.) — all API calls go directly in the `Api` class.
- No business logic in the data layer — serialization and domain conversion only.
- One `Api` class holds all GraphQL/REST calls. If it grows large, split it using extensions or mixins on the same `Api` class.
- Api methods stay simple: accept params, call the endpoint, return domain models after `toDomain()`.
- Error handling returns an `ApiError` model — not raw exceptions.
- Token refresh and force-logout are handled as callbacks set by `AuthenticationService`.
- Data transformation (building maps/params) goes in the Api layer or a private method — never inline inside a repository method.

---

## 4. Domain Layer — Models

- Every model is a `@freezed` sealed class — no mutable state.
- Computed/derived properties go in an extension on the same model file — not inside the class body.
- If the getter contains domain knowledge (mappings, business rules) → extension on the **Model**.
- If the getter is presentation/display logic → extension on the **State**.

---

## 5. Domain Layer — Repositories

- Repository is a thin wrapper around `Api` — no abstract interface needed.
- If a method does more than one Api call, the repository is the right place to compose them.
- If the repository has an event stream (e.g. `onFavoriteToggled`) — the stream lives in the repository.

---

## 6. Domain Layer — Services

- Create a service only when there is complex business logic that goes beyond a single call.
- Services are the only place for cross-feature operations (e.g. `AuthenticationService` calling `CheckoutService`).
- A service may contain `StreamController.broadcast()` for events consumed by multiple cubits.
- Services own side effects: save to local storage, clear cache, notify other services.

---

## 7. Presentation Layer — State

```dart
@freezed
sealed class XxxState with _$XxxState {
  const factory XxxState({
    @Default(false) bool isLoading,
    // ...
  }) = _XxxState;
}

extension XxxStateX on XxxState {
  bool get canDoSomething => !isLoading && data != null;
}
```

- State is always a `@freezed` sealed class.
- Computed properties go in `extension XxxStateX on XxxState` — never inside the class body.
- Do not use the `const Xxx._()` trick — put methods in the extension instead.
- State contains no methods — only fields and extension getters.
- Extension lives in the same file as the state.

Decide where a getter lives:

| Getter type | Where it lives |
|---|---|
| Business / data logic | Extension on **Model** |
| Domain knowledge (mappings, business rules) | Extension on **Model** |
| UI / display / coordination logic | Extension on **State** |
| Pure transformation on a single value, no state dependency | Extension on **that type** directly |

---

## 8. Presentation Layer — Cubit

```dart
class XxxCubit extends Cubit<XxxState> {
  final XxxRepository _xxxRepository;

  XxxCubit(this._xxxRepository) : super(const XxxState());

  void initialize() async {
    emit(state.copyWith(isLoading: true));
    final result = await _xxxRepository.fetchXxx();
    emit(state.copyWith(isLoading: false, data: result));
  }
}
```

- Cubit receives dependencies via constructor injection from GetIt.
- Cubit starts with an `initialize()` method called by the screen on `initState`.
- The Cubit is the only place allowed to call `emit`.
- Cubit methods map to user intents or lifecycle events — not to internal implementation steps.
- Guard checks (e.g. `if (!state.canLoadMore) return;`) live inside the Cubit — not in the screen.
- For parallel loading — use `Future.wait([...])`, then emit once after all results are ready.
- Optimistic updates: emit the new state → call API → if it fails, emit the old state back.
- If multiple booleans represent a single exclusive state — use an `enum` instead.
- Don't expose internal Cubit state as public fields or methods.

---

## 9. Presentation Layer — Screen

```dart
class XxxScreen extends StatefulWidget {
  @override
  State<XxxScreen> createState() => _XxxScreenState();
}

class _XxxScreenState extends State<XxxScreen> {
  late final XxxCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<XxxCubit>()..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<XxxCubit, XxxState>(
        builder: (context, state) { ... },
      ),
    );
  }
}
```

- Screen contains no business logic — only UI, navigation, dialogs, and pickers.
- Screen calls Cubit methods directly without performing state checks first — guards live in the Cubit.
- Screen reads state through extension getters — avoid raw multi-field access when the logic spans multiple fields.
- Computed properties on `StatefulWidget` (e.g. `identifier`, `isSectionBased`) are acceptable when derived purely from constructor params.

---

## 10. Form Rules

- Form validation is the single source of truth for field-level validation UI.
- Use `_hasAttemptedSubmit` as local screen state and `autovalidateMode` on the `Form` widget.
- Validator functions are static methods defined in the screen file.
- Non-text fields (dropdowns, multi-select, date pickers) use `FormField` wrappers defined in the screen.
- The Cubit's submit method trusts the screen already validated — it does not re-validate field by field.
- State holds no `canSubmit` getter and no per-field error strings.

### TextField UX

- Connect fields with `FocusNode` and set `textInputAction: TextInputAction.next` on every field except the last — the last uses `done`, `send`, `go`, or `search` where appropriate.
- Set `autovalidateMode: AutovalidateMode.onUserInteraction` so errors appear as the user types, not only on submit.
- Set the correct `keyboardType` for every field: `emailAddress`, `phone`, `number`, `multiline`, `url` — never leave it as default when the context is known.
- Set `autofillHints` on relevant fields: `AutofillHints.email`, `AutofillHints.password`, `AutofillHints.telephoneNumber`, etc.
- Disable autocorrect and suggestions on sensitive fields — `autocorrect: false`, `enableSuggestions: false` on email, password, and any structured-input field.
- Use `inputFormatters` to enforce format constraints: digit limits, currency formatting (e.g. `10,000`), masks — never rely on validator alone for format enforcement.
- Wrap the screen in a `GestureDetector` with `onTap: () => FocusScope.of(context).unfocus()` so tapping outside any field dismisses the keyboard.
- For search fields that trigger API calls — debounce the request (300–500 ms). Never fire a request on every keystroke.

---

## 11. Performance Rules

- Use `const` constructors everywhere possible — widgets, decorations, text styles, padding.
- Prefer `BlocSelector` or `context.select` over `BlocBuilder` when only a subset of state is needed.
- Use `buildWhen` on `BlocBuilder` / `BlocConsumer` to skip rebuilds when the relevant slice of state has not changed.

  ```dart
  // ✅
  BlocBuilder<OrderCubit, OrderState>(
    buildWhen: (prev, curr) => prev.status != curr.status,
    builder: (context, state) => StatusBadge(state.status),
  );

  // ❌ rebuilds on every state emission
  BlocBuilder<OrderCubit, OrderState>(
    builder: (context, state) => StatusBadge(state.status),
  );
  ```

- Use `listenWhen` on `BlocListener` / `BlocConsumer` for the same reason.
- Avoid creating objects (lists, maps, styles) inside `build` — move them to `const` or compute once outside the build method.
- Choose the right scroll widget based on content type:

  | Situation | Solution |
    |---|---|
  | Fixed screen with no list (login, settings, form) | `SingleChildScrollView` |
  | List only, unbounded or large data | `ListView.builder` |
  | Short fixed list (< ~20 items) | Plain `Column` is acceptable |
  | Mixed content (form + list, header + list) | `CustomScrollView` + Slivers |
  | Nested list inside a scroll view | `SliverList` — never `shrinkWrap: true` |

    - Never use `shrinkWrap: true` on a `ListView` inside a scroll view — it builds all items at once and triggers a double layout pass, making it worse than `SingleChildScrollView`.
- Avoid calling expensive getters inside `build` repeatedly — assign to a local variable once.

---

## 12. Dependency Injection (GetIt)

- `registerLazySingleton` → repositories, services, data sources, Api.
- `registerFactory` → cubits (so each screen gets a fresh instance).
- Exception: use `registerLazySingleton` for cubits that must survive the full app lifecycle (e.g. `TabCubit`, `CartCubit`).
- Registration order: data sources → Api → repositories → services → cubits.

---

## 13. Naming Conventions

| Artifact | Convention | Example |
|---|---|---|
| Module folder | `snake_case` | `order_tracking/` |
| Api model | `ApiPascalCase` | `ApiOrder` |
| Domain model | `PascalCase` | `Order` |
| Repository class | `PascalCaseRepository` | `OrderRepository` |
| Service class | `PascalCaseService` | `PricingService` |
| Cubit class | `PascalCaseCubit` | `OrderTrackingCubit` |
| State class | `PascalCaseState` | `OrderTrackingState` |
| State extension | `PascalCaseStateX` | `OrderTrackingStateX` |
| Screen file | `feature_name_screen.dart` | `order_tracking_screen.dart` |

---

## 14. File Structure

```
lib/
├── core/
│   ├── di/                  # GetIt setup
│   ├── networking/          # Api class + ApiError models
│   ├── services/            # Cross-feature app services
│   ├── theming/
│   ├── extensions/          # App-wide type extensions
│   └── utilities/
└── modules/
    └── order_tracking/
        ├── data/
        │   ├── models/          # ApiXxx models (Freezed + fromJson + toDomain)
        │   └── data_sources/    # Local storage only (SharedPrefs, Hive…)
        ├── domain/
        │   ├── models/          # Clean domain models (Freezed + extension)
        │   ├── repositories/    # Thin Api wrappers
        │   └── services/        # Complex business logic only
        └── presentation/
            ├── cubits/
            │   └── order_tracking/
            │       ├── order_tracking_cubit.dart
            │       └── order_tracking_state.dart   # state + extension in same file
            ├── screens/
            └── widgets/
```

---

## 15. Code Generation Rules

- Generated files (`*.freezed.dart`, `*.g.dart`, l10n generated files) are the developer's responsibility.
- Only edit source files (`*.dart` without the generated suffix).
- Never manually edit or regenerate `*.freezed.dart` or `*.g.dart` files — the developer runs `build_runner`.
- Never run `gen-l10n` — the developer handles localization generation.
- When creating a new freezed class, write only the source file and add a comment `// run build_runner` at the top — do not simulate or write the generated output.