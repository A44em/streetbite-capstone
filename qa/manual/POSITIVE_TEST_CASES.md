# Positive Test Suite

Positive-path coverage is defined by the following canonical cases in
`TEST_CASES.md`: TC_ONBOARD_001, TC_LOGIN_001, TC_SIGNUP_001, TC_HOME_001,
TC_HOME_002, TC_MEAL_001, TC_FAV_001, TC_CART_001, TC_CART_002, TC_ORDER_001,
TC_MAP_001, TC_PROFILE_001, TC_PROFILE_003, TC_PROFILE_004, TC_LOCALE_001,
TC_THEME_001, TC_RESPONSIVE_001, and TC_LIFECYCLE_001.

Executed 2026-10-20: all Pass except TC_MAP_001 (Blocked: bonus map, no Maps key) and
TC_PROFILE_003 (Blocked live: avatar rule awaiting deployment approval; verified on the Emulator
Suite). Evidence is linked per case in `TEST_CASES.md`.
