# Manual QA Requirements Traceability Matrix

Statuses as executed on 2026-10-20 (see `TEST_CASES.md` for per-case evidence).
Appium results refer to run 8 on the final signed APK (`386c095e…7996`), emulator only.

| Requirement | Test cases | Automation | Current evidence status |
|---|---|---|---|
| Onboarding animation | TC_ONBOARD_001 | Setup step in every Appium test | Manual Pass |
| Authentication and validation | TC_LOGIN_001–003, TC_SIGNUP_001–002 | `AuthenticationTest` (valid, invalid, empty) | Manual Pass (5/5); Appium Pass (3/3) |
| Live and cached meals | TC_HOME_001–003 | `HomeTest.scrollThroughMealGrid` | Manual Pass (3/3); Appium Pass |
| Details and favourites | TC_MEAL_001, TC_FAV_001 | Not automated | Manual Pass (2/2) |
| Cart and orders | TC_CART_001–002, TC_ORDER_001–002 | `HomeTest.addMealShowsSnackBar` | Manual Pass (4/4); Appium Pass |
| Vendor map (bonus) | TC_MAP_001 | Not automated | Blocked: no Maps API key |
| Profile, biometrics, photo, device | TC_PROFILE_001–004 | Not automated | 001, 002, 004 Pass (emulator-simulated fingerprint); 003 Blocked live (verified on Emulator Suite; avatar rule awaiting deploy) |
| Arabic/RTL and theme | TC_LOCALE_001, TC_THEME_001 | Not automated | Manual Pass (2/2) |
| Responsive/mobile behavior | TC_RESPONSIVE_001, TC_LIFECYCLE_001 | Not automated | Manual Pass (2/2): phone + emulated tablet |
| User data isolation | TC_SECURITY_001 | `qa/firebase-rules` (20 emulator tests) + live cross-user script | Pass: emulator 20/20, live 11/11 |

Totals: 23 Pass, 0 Fail, 2 Blocked, 0 Not Run. Physical-device execution: not performed.
