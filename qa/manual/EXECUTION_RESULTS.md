# QA Execution Results

Date: 2026-10-19 (Africa/Cairo)

## Automated Engineering Checks

| Check | Actual result | Status | Evidence |
|---|---|---|---|
| `dart format lib test` | Completed successfully | Pass | Terminal run, 2026-10-19 |
| `flutter analyze` | No issues found | Pass | Terminal run, 2026-10-19 |
| `flutter test` | 6 tests passed | Pass | Terminal run, 2026-10-19 |
| Android debug build | Built successfully after clean cache | Pass | SHA-256 `a8a6e49fa9c4834249c666ba768b5d7e45eb47cfa3f10b12cb800e070ed9e620` |
| Android release-mode build | Built successfully; debug-key signed | Pass | SHA-256 `652321aee0bc90d035c0f3ac6e41f7bf8529fa76d2b4abd737546769068b4dd5` |
| Universal APK install | Emulator reported insufficient internal storage | Blocked | Prior ADB install output |
| ARM64 APK install | Emulator package manager became unresponsive | Blocked | Prior bounded ADB attempt |
| Release APK install | Fully booted emulator package manager became unresponsive | Blocked | Bounded ADB attempt, 2026-10-19 |

## Manual Cases

All cases in `TEST_CASES.md` are `Not Run`. Source inspection, analyzer output,
and unit tests are not substitutes for manual GUI execution.

## Appium

The executable project exists under `qa/appium`. Maven compilation and Appium
device execution are not yet verified; status is `Not Run` pending tool and
device checks.
