# StreetBite Appium Automation

This independent Maven project targets Appium 2 with the UiAutomator2 driver.
It contains page objects, explicit waits, failure screenshots, and five required
scenarios: valid login, invalid login, empty login fields, home-grid scrolling,
and add-to-cart feedback.

## Prerequisites

- Java 17 and Maven
- Node.js and Appium 2
- UiAutomator2 driver (`appium driver install uiautomator2`)
- A booted Android emulator or connected Android device
- A current StreetBite debug APK

## Environment

```bash
export APK_PATH=/absolute/path/to/app-debug.apk
export ANDROID_UDID=emulator-5554
export ANDROID_DEVICE_NAME='Android Emulator'
export STREETBITE_TEST_EMAIL='authorized-test-account@example.com'
export STREETBITE_TEST_PASSWORD='test-account-password'
```

Credentials remain environment-only and are never stored in the repository.

## Execution

```bash
appium driver install uiautomator2
appium
cd qa/appium
mvn clean test
```

TestNG reports are written to `target/surefire-reports`; screenshots for failed
tests are written to `target/screenshots`. Physical-device execution uses the
same suite with `ANDROID_UDID` set to the connected device serial.

## Verification Status

Executed 2026-10-20 on the `StreetBite_API_36` emulator: run 8 against the final production-signed
APK (`386c095e…7996`) gave 5 passed, 0 failed, 0 skipped (TestNG reports archived under
`evidence/runtime/appium/closure-2026-10-20/run8-final-apk-5of5/`). Physical-device execution has
not been performed. Credentials come only from `STREETBITE_TEST_EMAIL` / `STREETBITE_TEST_PASSWORD`.
