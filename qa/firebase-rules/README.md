# Firebase Rules Tests

Security-rule tests for `firestore.rules` and `storage.rules`.

## Emulator suite (no live data touched)

Requires Node 18+, Firebase CLI, and Java 21 (for example Android Studio's bundled JBR).

```bash
cd qa/firebase-rules
npm ci
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" npm test
```

This starts the Firestore and Storage emulators (`demo-streetbite` project) via
`../../firebase.deploy.json` and runs `rules.test.mjs` (19 tests).

## Live cross-user check (read-mostly, denied writes)

`node live-cross-user-check.mjs` signs in two QA accounts whose credentials are read from
`~/.config/streetbite-qa/*.env` (never committed). It verifies that one user cannot read
or write the other's data. Only HTTP statuses are printed.
