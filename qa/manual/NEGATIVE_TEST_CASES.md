# Negative Test Suite

Negative and recovery coverage is defined by TC_LOGIN_002, TC_LOGIN_003,
TC_SIGNUP_002, TC_HOME_003, TC_ORDER_002, TC_PROFILE_002, and TC_SECURITY_001
in `TEST_CASES.md`.

Executed 2026-10-20: all seven cases Pass. Boundary additions covered include oversized profile
images (500 KB Firestore rule and client check), Firestore permission denial, malformed API responses, repeated checkout taps, expired
authentication, and denied photo permissions. New failures receive a local
defect ID in `JIRA_DEFECT_LOG.csv`; a Jira key is recorded only after Jira
actually creates the issue.
