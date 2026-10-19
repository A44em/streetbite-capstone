# StreetBite V1.0 — Graduation Presentation

## Slide 1 — StreetBite

**Bilingual food discovery and demo ordering with Flutter**
Developer: Assem Ali
Version: 1.0

Visual: StreetBite mark plus a genuine final home-screen screenshot.

## Slide 2 — Problem and Objective

- Meal discovery is fragmented across menus and vendor pages.
- StreetBite presents a responsive catalogue with saved access and ordering flow.
- English/Arabic, RTL, theming, and accessibility support broaden usability.

## Slide 3 — Planning and Recovery

- Requirements mapped to implementation and evidence.
- Evaluator findings converted into traceable recovery work.
- Safe Git checkpoint created before implementation.
- Verification claims separated from external blockers.

## Slide 4 — Clean Architecture

- Domain: entities, contracts, use cases, payment strategies
- Data: Dio API, JSON models, SharedPreferences cache, repository factory
- Presentation: screens, Bloc/Cubit state, reusable widgets
- Infrastructure: GetIt and Firestore singleton

Visual: three-layer diagram with dependency direction toward Domain.

## Slide 5 — Technology Stack

- Flutter and Dart
- flutter_bloc and GetIt
- Firebase Auth, Firestore, Storage, App Distribution
- Dio, TheMealDB, SharedPreferences
- Google Maps, local_auth, image_picker, device_info_plus
- Appium 2, UiAutomator2, Java, Maven, TestNG

## Slide 6 — Main Features

- Persistent authentication and onboarding
- Featured meals, offers, responsive grid, offline cache
- Details, favourites, cart, payment strategy, Firestore orders
- Vendor map, protected profile, image upload, device details

## Slide 7 — Patterns and SOLID

- Builder: validated `UserModelBuilder`
- Factory: remote/cache `MealRepositoryFactory`
- Singleton: shared `FirestoreService`
- Strategy/interface segregation: cash and demo-card payment methods
- Dependency inversion through domain repository contracts

## Slide 8 — Arabic, English, Light, Dark

- ARB-based localization
- Runtime RTL/LTR direction through Flutter localization
- Persisted locale and theme preferences
- Consistent Material 3 color system

Visual: genuine side-by-side English/Arabic and light/dark screenshots.

## Slide 9 — Quality Engineering

- Analyzer and Flutter unit tests
- Manual functional, GUI, negative, mobile, and security suites
- Appium page objects, explicit waits, stable semantics identifiers
- Requirements traceability and defect import records

## Slide 10 — Security and Release

- User-owned Firestore paths and Storage objects
- Environment-only Firebase, Maps, signing, and test credentials
- Debug/release build gates and CI validation
- Firebase App Distribution with authorized testers

## Slide 11 — Challenges and Solutions

- Recovered malformed source and broken dependency wiring
- Removed ignored-file compile dependency
- Addressed missing Builder, listener, reusable widgets, and persistence
- Isolated emulator/resource and external-account blockers honestly

## Slide 12 — Results and Next Steps

- Maintainable capstone source and professional QA package
- Verified checks displayed from final report
- Final device evidence, signing, distribution, and two-tester confirmation
- Conclusion: a traceable path from source implementation to release evidence

Presentation export should use StreetBite orange (`#E86B36`), warm neutral
backgrounds, high-contrast typography, and only genuine application screenshots.
