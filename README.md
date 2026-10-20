# StreetBite V1.0

StreetBite is a bilingual Flutter application for discovering meals and
demonstrating a food-ordering workflow. Meal data is provided by TheMealDB,
while Firebase supports authentication and user-scoped application data.

## Features

- English and Arabic localization with runtime language switching
- Material 3 light and dark themes
- Firebase email/password authentication
- Remote meal catalogue powered by TheMealDB
- Offline meal caching with `shared_preferences`
- Meal details, favourites, cart, and demo checkout flows
- User profiles, profile images, order history, and device information
- Google Maps vendor locations
- Biometric protection for profile access

## Architecture

The source follows a Clean Architecture-inspired structure:

- `lib/domain` — entities, repository contracts, use cases, and payment strategies
- `lib/data` — remote and cached data sources, models, and repository implementations
- `lib/presentation` — screens and Bloc/Cubit state management
- `lib/core` — shared services and infrastructure
- `lib/l10n` — English and Arabic ARB resources and generated localization code

Dependencies are registered through GetIt in `lib/injection.dart`.

## Requirements

- Flutter 3.44.0 or a compatible stable release
- Dart 3.12.0 or a compatible SDK
- Android SDK with accepted licenses
- A Firebase Android application registered as `com.a44em.streetbite`
- A restricted Google Maps API key for the same Android package

## Configuration

Firebase configuration is maintained locally and excluded from version control:

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `firebase.json`

The Firebase project requires Email/Password Authentication, Cloud Firestore,
and Firebase Storage. Firestore and Storage rules should restrict data to the
authenticated owner.

The Google Maps key is supplied through the ignored
`android/local.properties` file:

```properties
MAPS_API_KEY=your_restricted_android_maps_api_key
```

`android/local.properties.example` documents the expected property without
containing a real credential.

Production signing uses an ignored `android/key.properties` file. The expected
fields are documented in `android/key.properties.example`. Without that file,
release-mode builds use the Android debug key for diagnostics only and are not
eligible for production distribution.

## Development

```bash
flutter pub get
flutter gen-l10n
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

## Quality Engineering

- `test/` contains Flutter unit tests for meals, cart behavior, the user Builder,
  and preference persistence.
- `qa/manual/` contains the manual test plan, canonical cases, execution record,
  traceability, defect-import CSV, and closure report.
- `qa/appium/` is an independent Java/Maven Appium 2 project using UiAutomator2,
  page objects, explicit waits, and failure screenshots.
- `docs/` records requirements coverage, gaps, verification, release blockers,
  and the final submission checklist.
- `evidence/` defines the required genuine screenshot and distribution artifacts.

Public repository: https://github.com/A44em/streetbite-capstone

## Verification Status

Final verification 2026-10-20 (details in `submission/FINAL_SUBMISSION_READINESS.md`):

- `dart format` check: 0 changes; `flutter analyze`: no issues
- Automated tests: 6/6 passing
- Android debug build: successful; installed and launched on an API 36 emulator
- Appium (5 scenarios): 5 pass, 0 fail, 0 skipped (disposable test account)
- Manual QA (25 cases): 17 pass, 5 fail, 3 blocked — all 5 fails trace to Firebase
  backend configuration (deployed Firestore rules, Storage bucket), not app code
- Release-mode APK: builds, but debug-key signed (no production keystore)
- Physical-device validation and Firebase App Distribution: not performed

## Demo Pricing

TheMealDB does not provide commercial pricing. StreetBite derives stable demo
prices for interface and checkout demonstrations. These values are not vendor
offers, and the application does not process real payments.

## Security

Service-account files, Firebase client configuration, API keys, private signing
keys, local SDK paths, and generated build outputs are excluded from version
control.
