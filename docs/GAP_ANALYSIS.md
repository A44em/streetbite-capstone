# StreetBite V1.0 Gap Analysis

## Source-of-Truth Audit

Only one Flutter project exists in the workspace:
`/Users/assemali/Desktop/Flutter/flutter_app`. It contains `pubspec.yaml`, the
Android runner, current application source, and the Git repository. The
workspace-level `docs/`, `qa/`, rules, and CI files were legacy delivery files
outside the Git repository and contained stale claims. Current deliverables are
therefore maintained inside `flutter_app`.

The safe recovery checkpoint is branch
`checkpoint/pre-recovery-2026-10-19` at commit `95811d2`.

## Evaluator Findings

| Finding | Audit result | Recovery action |
|---|---|---|
| Manual QA incomplete | Legacy draft outside repository | Complete package added under `qa/manual`; execution remains truthful |
| Appium Java missing | No automation project | Maven/Appium/UiAutomator2 project and five scenarios added |
| Screenshots missing | No genuine evidence | Evidence inventory added; capture remains blocked until responsive target |
| App Distribution missing | No console evidence/testers | Release procedure documented; external action remains blocked |
| GitHub URL missing | Remote exists | Repository URL recorded in documentation |
| User Builder missing | Confirmed absent | `UserModel` and `UserModelBuilder` added and unit-tested |
| Explicit BlocListener missing | Cart used `BlocConsumer` | Separate explicit `BlocListener` and `BlocBuilder` added |
| Reusable widgets missing | Screen-local UI confirmed | `MealImage`, `MealCard`, and `CartItemTile` extracted |
| Device/emulator verification incomplete | Prior AVD install failures | Cases, defect records, and rerun instructions added; still blocked |

## Additional Confirmed Gaps

- Theme and locale selections were not persisted; persistence and tests were added.
- `main.dart` imported ignored `firebase_options.dart`, preventing clean-clone
  compilation; Android now uses native Firebase configuration without that
  compile-time dependency.
- Firebase rules existed only outside the repository; strengthened rules are
  now versioned with the app.
- UI automation lacked stable identifiers; Semantics identifiers were added to
  onboarding, authentication, meal grid, cart, and meal actions.
- Production signing, Firebase rule-emulator tests, screenshots, physical-device
  biometrics, and distribution remain dependent on external credentials/devices.
