# StreetBite V1.0 Manual Test Plan

## Purpose

This plan validates functional behavior, localization, accessibility, security,
resilience, and Android compatibility for StreetBite V1.0.

## Scope

The covered screens and flows are splash/onboarding, sign-up, sign-in, home,
meal details, favourites, cart, checkout, vendor map, biometric profile access,
profile image, order history, theme switching, and English/Arabic localization.

## Test Levels

- Functional and GUI testing
- Positive and negative validation
- Integration testing for Firebase Auth, Cloud Firestore (including the profile photo), TheMealDB and Maps
- Offline/cache and interrupted-network testing
- Localization, RTL, accessibility, and responsive-layout testing
- Installation, upgrade, lifecycle, permission, and mobile compatibility testing

## Environments

| Environment | Target | Status |
|---|---|---|
| Emulator A | `StreetBite_API_36`, Android 16 / API 36, 1080×2400 | Used for all execution (2026-10-20) |
| Emulator B | Same AVD with `wm size 1600x2560`, 320 dpi (tablet profile) | Used for TC_RESPONSIVE_001 |
| Physical Android | Android 10+ with biometrics | Not available: physical-device runs not performed |
| Backend | Firebase project `streetbite-f0a77` | Firestore rules deployed and verified 2026-10-20; avatar rule pending deploy |

## Entry Criteria

- Analyzer and unit tests pass.
- Debug APK builds successfully.
- Firebase, Maps, and test-account configuration is available locally.
- Test data is isolated from production data.

## Exit Criteria

- All critical and high-priority cases have Pass results on two Android sizes.
- No unresolved critical/high defects remain.
- Firebase ownership isolation is verified with two distinct accounts.
- Appium reports exist for emulator execution and three login cases on hardware.
- Release APK installation and smoke testing are complete.
- Evidence references resolve to genuine screenshots or logs.

## Roles

| Role | Responsibility |
|---|---|
| QA lead | Scope, execution control, defect triage, closure |
| Mobile tester | Manual execution on emulator and hardware |
| Automation engineer | Appium maintenance and report capture |
| Developer | Root-cause fixes and unit/widget tests |
| Release owner | Signing, distribution, tester access, evidence retention |

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Firebase credentials unavailable | Auth/profile/order tests blocked | Use authorized environment-only configuration |
| Emulator storage/RAM limitations | Install and execution blocked | Use a smaller AVD or physical device and ABI-split APK |
| Maps key restriction mismatch | Blank map | Match package and signing SHA restrictions |
| Biometric hardware unavailable | Profile gate blocked | Execute on biometric-capable physical hardware |
| Network instability | Flaky API tests | Record connectivity and validate cached fallback separately |

## Deliverables

The package includes detailed cases, categorized suites, execution results,
defect records, traceability, and a closure report under `qa/manual/`.
