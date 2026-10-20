# Firebase Rules Tests

Security-rule tests for `firestore.rules` (profile, avatar photo, favourites, orders).
Cloud Storage is not used: the profile photo is stored in Firestore.

## Emulator suite (no live data touched)

Requires Node 18+, Firebase CLI, and Java 21 (for example Android Studio's bundled JBR).

```bash
cd qa/firebase-rules
npm ci
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" npm test
```

This starts the Firestore emulator (`demo-streetbite`) via `../../firebase.deploy.json` and runs
`rules.test.mjs` (20 tests).

## App against the emulator (unreleased rules)

Debug builds accept `--dart-define=USE_FIRESTORE_EMULATOR=true` to point Firestore at
`10.0.2.2:8080`, so unreleased rules can be exercised by the real app before deployment.

## Live cross-user check

`node live-cross-user-check.mjs` signs in two QA accounts (credentials from
`~/.config/streetbite-qa/*.env`, never committed) and verifies that one user cannot read or
write the other's data. Only HTTP statuses are printed.
