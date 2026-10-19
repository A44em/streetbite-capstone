# Release Blockers

## Blocking Submission Evidence

1. A responsive Android emulator with sufficient storage or a physical device
   is required for installation, full smoke testing, and genuine screenshots.
2. A production Android signing keystore and secure signing variables are
   required. The inherited Android configuration uses debug signing for the
   release build and is not suitable for distribution.
3. Firebase project access is required to deploy and test Firestore/Storage
   rules, upload the release, and capture genuine console evidence.
4. At least two authorized tester email addresses are required for Firebase App
   Distribution.
5. A restricted Google Maps Android key must be present in ignored local
   configuration and validated against the release signing certificate.
6. A biometric-capable physical Android device is required for the mandated
   profile gate and the three physical-device login automation scenarios.
7. Jira access is required to import `qa/manual/JIRA_DEFECT_LOG.csv`; no Jira
   keys are claimed before import.

## Environment Warnings

- `flutter doctor -v` reported missing Android command-line tools and unknown
  aggregate license status.
- The existing AVD recommends more host RAM than the available machine.

## Non-Blocking Source Work

Analyzer, Flutter tests, Appium source review, debug build, and a diagnostic
release build can proceed locally without claiming distribution readiness.
Appium compilation and execution require Java, Maven, Appium 2, and a usable
Android target.
