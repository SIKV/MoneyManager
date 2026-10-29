# Money Manager

- Offline personal finance tracker built with Flutter (Android + iOS). 
- User data is stored only on the device (Isar); there is no backend. 
- Prod builds also send Firebase Analytics screen views and Sentry crash reports. Both are off unless enabled with `--dart-define` (see `lib/config.dart`).

## Commands
- After changing `@freezed`, `@riverpod` or Isar classes: `dart run build_runner build --delete-conflicting-outputs`. Generated `*.g.dart` and `*.freezed.dart` files aren't committed, so run this after a fresh checkout too.
- Run: `flutter run --flavor dev` on Android (it has `dev` and `prod` flavors); plain `flutter run` on iOS.

## Architecture
- State: Riverpod, mostly hand-written notifiers. Only `app_startup.dart` uses `@riverpod` codegen.
- Features live in `lib/feature/<name>/`, usually split into `controller/`, `domain/` and `ui/`.
- Shared widgets are in `lib/ui/widget/`.

## Navigation conventions
- Navigation uses named routes. To add a screen: add a constant to `AppRoutes`, then add a case to `onGenerateRoute` in `app_startup.dart`.
- Pass arguments as typed `*Args` classes through `settings.arguments`.
- Bottom-sheet modals use `ModalBottomSheetRoute`, and their route names end in `-modal`.

## UI conventions
- Every user-facing string goes in `lib/l10n/app_en.arb` and is read with `AppLocalizations.of(context)!.key`. Lowercase variants use an `l` prefix (`lIncome`, `lTransactions`).
- Use `Spacings.*` for padding and gaps. Border radius uses `AppRadius.*` (`theme/radius.dart`), never `Spacings`.
- Standard Material colors come from `Theme.of(context).colorScheme`. App-specific colors (income/expense, chart, header gradients) come from `ref.watch(appThemeManagerProvider).colors`. Don't hard-code colors.
- SVG icons live in `assets/` and are referenced through `theme/assets.dart`.
- The app is portrait only.

# Guidelines

<!-- 
Source: https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md
Copied: 2026-10-29.
-->

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
