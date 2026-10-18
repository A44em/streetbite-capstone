# StreetBite V1.0 — implementation starter

**Status: PARTIAL IMPLEMENTATION — NOT SUBMISSION READY.** This repository is a working-source starter, not a tested production release. Flutter SDK and Firebase credentials are not available in the authoring environment; compilation and device tests have **not** been run.

## Implemented source
- Flutter app shell; Material 3 light/dark and runtime EN/AR locale switch (ARB)
- Firebase email/password login and sign-up; persisted auth via Firebase SDK
- TheMealDB remote meals with Dio and shared_preferences offline cache
- Meal detail navigation, demo-priced cart, two-column responsive meal grid, banners, offers
- Data/Domain/Presentation separation, GetIt DI, repository factory

## Required before build
1. Install Flutter SDK / Android SDK; run `flutter doctor`.
2. `cd flutter_app && flutter pub get`.
3. Configure a Firebase Android app and use FlutterFire CLI (`flutterfire configure`) to generate platform configuration. Enable Email/Password Auth, Firestore and Storage with per-user rules.
4. Add Android/iOS platform folders with `flutter create --platforms=android,ios .` if absent.
5. Run `flutter gen-l10n`, `dart format .`, `flutter analyze`, `flutter test`, then `flutter run` and fix any SDK-version issues.
6. Complete all missing required features before submission, then produce release APK and Firebase App Distribution evidence with two real testers.

## Incomplete features — must not claim completed
- Figma fidelity audit (original assignment Figma URL was not supplied)
- Firestore profile/favourites/orders and security rules; payment interfaces
- Profile photo, Firebase Storage, device info, biometric gate
- Google Maps markers, onboarding/splash animation
- QA evidence, Jira logs, Appium, beta distribution, screenshots, GitHub upload
- Native Android configuration, Firebase config, physical-device tests

## Pricing disclaimer
TheMealDB does not provide ordering prices. The app computes stable **demo prices**, not real vendor offers. No real payment processing is implemented.

## Security
Never commit service account keys, secrets, or private signing keys. Restrict Firestore and Storage to the authenticated owner. Do not claim release/testing evidence without actual results.
