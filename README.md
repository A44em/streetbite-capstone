# StreetBite V1.0

The Dart application compiles, passes static analysis and its current automated
tests, and produces an Android debug APK. Runtime Firebase and Google Maps
configuration is intentionally not stored in this repository and must be added
locally before those features can be exercised.

## Implemented source
- Flutter app shell; Material 3 light/dark and runtime EN/AR locale switch (ARB)
- Firebase email/password login and sign-up; persisted auth via Firebase SDK
- TheMealDB remote meals with Dio and shared_preferences offline cache
- Meal detail navigation, demo-priced cart, two-column responsive meal grid, banners, offers
- Data/Domain/Presentation separation, GetIt DI, repository factory

## Local setup

1. Install Flutter and the Android SDK, including Android SDK command-line tools,
   then accept the Android licenses.
2. Run `flutter pub get` and `flutter gen-l10n`.
3. Register an Android app with application ID `com.a44em.streetbite` in the
   real Firebase project. Run `flutterfire configure` to wire the Android
   Google Services plugin and generated configuration. Enable Email/Password
   Authentication, Firestore, and Storage, and deploy user-scoped security
   rules. Do not commit `android/app/google-services.json`,
   `lib/firebase_options.dart`, service-account files, or signing keys.
4. Add `MAPS_API_KEY` to the generated, ignored `android/local.properties`
   file, preserving its `sdk.dir` and `flutter.sdk` values. The committed
   `android/local.properties.example` documents the expected key. Restrict the
   Android Maps key to package `com.a44em.streetbite`.
5. Run `dart format .`, `flutter analyze`, `flutter test`, and
   `flutter build apk --debug`.

## Incomplete features — must not claim completed
- Figma fidelity audit (original assignment Figma URL was not supplied)
- Firestore profile/favourites/orders and security rules; payment interfaces
- Profile photo, Firebase Storage, device info, biometric gate
- Google Maps markers, onboarding/splash animation
- QA evidence, Jira logs, Appium, beta distribution, screenshots, GitHub upload
- Firebase project configuration, physical-device tests

## Pricing disclaimer
TheMealDB does not provide ordering prices. The app computes stable **demo prices**, not real vendor offers. No real payment processing is implemented.

## Security
Never commit service account keys, secrets, or private signing keys. Restrict Firestore and Storage to the authenticated owner. Do not claim release/testing evidence without actual results.
