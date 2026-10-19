# StreetBite V1.0 Requirements Matrix

Status values reflect source plus evidence as of 2026-10-19.

| ID | Requirement | Implementation | Status | Verification evidence |
|---|---|---|---|---|
| REQ-ARCH-01 | Clean Architecture layers | `lib/domain`, `lib/data`, `lib/presentation` | Implemented and verified | Analyzer and unit tests |
| REQ-ARCH-02 | GetIt dependency injection | `lib/injection.dart` | Implemented and verified | Analyzer/build |
| REQ-ARCH-03 | Builder pattern for user | `lib/data/models/user_model.dart` | Implemented and verified | `user_model_builder_test.dart` |
| REQ-ARCH-04 | Meal repository factory | `meal_repository_impl.dart` | Implemented and verified | Unit/integration source review |
| REQ-ARCH-05 | Firestore singleton | `firestore_service.dart` | Implemented but backend-unverified | Source review |
| REQ-AUTH-01 | Animated onboarding | `onboarding_screen.dart` | Implemented but unverified | Manual case TC_ONBOARD_001 |
| REQ-AUTH-02 | Firebase auth and persistence | `auth_cubit.dart`, `main.dart` | Implemented but unverified | Appium/login execution pending |
| REQ-AUTH-03 | Friendly login validation/errors | `auth_screen.dart`, ARB files | Implemented but unverified | TC_LOGIN_002–003 |
| REQ-AUTH-04 | Sign-up rules and profile creation | `auth_screen.dart`, `UserModelBuilder` | Implemented but unverified | Builder unit tests; Firebase run pending |
| REQ-HOME-01 | Live TheMealDB discovery | `remote_meal_source.dart`, `home_screen.dart` | Implemented but unverified | Device/API execution pending |
| REQ-HOME-02 | SharedPreferences cache | `cached_meal_source.dart` | Implemented but unverified | Offline device case pending |
| REQ-HOME-03 | Loading, empty, error and retry | `meal_cubit.dart`, `home_screen.dart` | Implemented but unverified | TC_HOME_001–003 |
| REQ-HOME-04 | Featured, five offers, responsive grid | `home_screen.dart`, `MealCard` | Implemented but unverified | Two-size visual QA pending |
| REQ-MEAL-01 | Details/navigation/cart feedback | `meal_details_screen.dart` | Implemented but unverified | TC_MEAL_001 |
| REQ-MEAL-02 | User Firestore favourites | `firestore_service.dart` | Implemented but backend-unverified | TC_FAV_001 |
| REQ-CART-01 | Reactive cart and totals | `cart_bloc.dart`, `cart_screen.dart` | Implemented and unit-verified | `cart_cubit_test.dart` |
| REQ-CART-02 | Explicit empty-cart BlocListener | `cart_screen.dart` | Implemented but UI-unverified | Source review; TC_CART_002 |
| REQ-CART-03 | Payment strategy and Firestore order | `payment_method.dart`, `firestore_service.dart` | Implemented but backend-unverified | TC_ORDER_001–002 |
| REQ-MAP-01 | Full-screen map and five vendors | `vendor_map_screen.dart`, Android manifest | Implemented but unverified | Maps key/device required |
| REQ-PROFILE-01 | Biometric profile gate | `profile_screen.dart`, `MainActivity.kt` | Implemented but physical-device-unverified | Hardware required |
| REQ-PROFILE-02 | Profile image Storage upload | `profile_screen.dart` | Implemented but backend-unverified | Storage/device case pending |
| REQ-PROFILE-03 | Device, orders, favourites | `profile_screen.dart` | Implemented but unverified | TC_PROFILE_004 |
| REQ-I18N-01 | English/Arabic and RTL | ARB files, `main.dart` | Implemented but visual-unverified | Localization generation; TC_LOCALE_001 |
| REQ-I18N-02 | Persistent light/dark theme | `theme_cubit.dart` | Implemented and unit-verified | `preference_cubits_test.dart` |
| REQ-I18N-03 | Persistent locale | `locale_cubit.dart` | Implemented and unit-verified | `preference_cubits_test.dart` |
| REQ-UX-01 | Reusable widgets | `lib/presentation/widgets` | Implemented and verified | Analyzer |
| REQ-QA-01 | Manual QA package | `qa/manual` | Implemented; execution incomplete | Documents present, cases Not Run |
| REQ-QA-02 | Appium Java project | `qa/appium` | Implemented but unverified | Maven/device execution pending |
| REQ-QA-03 | Emulator and device evidence | `evidence` | Blocked by external dependencies | No genuine screenshots yet |
| REQ-SEC-01 | User-scoped Firebase rules | `firestore.rules`, `storage.rules` | Implemented but emulator-unverified | Rules execution pending |
| REQ-REL-01 | Debug Android APK | Flutter build output | Implemented and verified | Successful debug build |
| REQ-REL-02 | Production-signed release | Android signing | Blocked by signing credentials | No production keystore |
| REQ-REL-03 | Firebase App Distribution, two testers | Firebase console | Blocked externally | Tester addresses/access unavailable |
| REQ-DEL-01 | Public GitHub repository | `A44em/streetbite-capstone` | Public repository verified; final publication pending approval | Unauthenticated `main` lookup succeeded at checkpoint `95811d2` |
| REQ-DEL-02 | Presentation | `presentation/STREETBITE_PRESENTATION.md` | Implemented as source deck | Export/visual review pending |
