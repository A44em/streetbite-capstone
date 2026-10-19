# StreetBite Manual Test Cases

Statuses are `Pass`, `Fail`, `Blocked`, or `Not Run`. `Not Run` is reserved for
cases without an execution attempt. Evidence references remain blank until a
real artifact is captured.

| ID | Requirement | Preconditions | Test steps | Test data | Expected result | Actual result | Status | Evidence |
|---|---|---|---|---|---|---|---|---|
| TC_ONBOARD_001 | REQ-AUTH-01 | Fresh app data | Launch app; observe animation; tap Get started | Fresh install | Branding fades in and authentication screen opens | Not executed | Not Run | — |
| TC_LOGIN_001 | REQ-AUTH-02 | Verified Firebase account | Enter valid email/password; submit | Authorized test account | Home opens and session persists after restart | Not executed | Not Run | — |
| TC_LOGIN_002 | REQ-AUTH-03 | Login screen; network online | Enter invalid credentials; submit | `invalid@example.com` / invalid password | Friendly localized credential error appears | Not executed | Not Run | — |
| TC_LOGIN_003 | REQ-AUTH-03 | Login screen | Leave fields empty; submit | Empty values | Email and password validation messages appear | Not executed | Not Run | — |
| TC_SIGNUP_001 | REQ-AUTH-04 | Unregistered email | Open sign-up; enter valid data; submit | Capitalized name, valid email, 6+ character password | Firebase account and Firestore profile are created | Not executed | Not Run | — |
| TC_SIGNUP_002 | REQ-AUTH-04 | Sign-up screen | Try lowercase name, invalid email, short/mismatched passwords | Boundary and invalid values | Submission is prevented with localized field errors | Not executed | Not Run | — |
| TC_HOME_001 | REQ-HOME-01 | Signed in; network online | Open home; wait for data | TheMealDB online | Featured area, five offers, and two-column phone grid render | Not executed | Not Run | — |
| TC_HOME_002 | REQ-HOME-02 | Cache populated | Disable network; relaunch/retry | Cached meal JSON | Saved meals render without data loss | Not executed | Not Run | — |
| TC_HOME_003 | REQ-HOME-03 | No cache; network unavailable | Clear app data; block network; open home | Offline/no cache | Error state and Retry action are visible | Not executed | Not Run | — |
| TC_MEAL_001 | REQ-MEAL-01 | Home contains meals | Open a meal | First visible meal | Image, name, category, area, and instructions match selection | Not executed | Not Run | — |
| TC_FAV_001 | REQ-MEAL-02 | Signed in; meal details open | Toggle favourite; open profile | Selected meal | User-scoped favourite appears or is removed in real time | Not executed | Not Run | — |
| TC_CART_001 | REQ-CART-01 | Home loaded | Add a meal; open cart | First visible meal | SnackBar, counter, item, currency, and total update | Not executed | Not Run | — |
| TC_CART_002 | REQ-CART-02 | Cart has one item | Remove item | Single cart item | Item disappears and explicit empty-cart SnackBar appears | Not executed | Not Run | — |
| TC_ORDER_001 | REQ-CART-03 | Signed in; cart non-empty | Select cash; place order | Two meals | Firestore order is created, success shown, then cart clears | Not executed | Not Run | — |
| TC_ORDER_002 | REQ-CART-03 | Signed in; cart non-empty | Interrupt Firestore; place order | Network blocked | Error appears and cart contents remain intact | Not executed | Not Run | — |
| TC_MAP_001 | REQ-MAP-01 | Maps key valid; network online | Open Nearby Vendors; tap marker | Cairo marker | Full-screen map shows at least five markers and correct info window | Not executed | Not Run | — |
| TC_PROFILE_001 | REQ-PROFILE-01 | Signed in; supported biometrics | Tap profile; authenticate | Enrolled biometric | Profile opens only after successful biometric verification | Not executed | Not Run | — |
| TC_PROFILE_002 | REQ-PROFILE-01 | Biometrics unavailable/cancelled | Tap profile; cancel or use unsupported device | Cancel/unsupported | Profile stays closed and localized feedback appears | Not executed | Not Run | — |
| TC_PROFILE_003 | REQ-PROFILE-02 | Profile open; Storage configured | Pick gallery image | JPEG under 5 MB | Upload completes and avatar updates from Firestore immediately | Not executed | Not Run | — |
| TC_PROFILE_004 | REQ-PROFILE-03 | Profile open | Review device, favourites, and orders | Existing user data | Device details and live user-scoped lists render | Not executed | Not Run | — |
| TC_LOCALE_001 | REQ-I18N-01 | Home open in English | Toggle Arabic; navigate all screens; restart | Arabic locale | All app strings translate, layout becomes RTL, selection persists | Not executed | Not Run | — |
| TC_THEME_001 | REQ-I18N-02 | Home open in light mode | Toggle dark mode; navigate and restart | Dark theme | All screens remain legible and dark preference persists | Not executed | Not Run | — |
| TC_RESPONSIVE_001 | REQ-UX-01 | Two Android screen profiles | Exercise core screens on both sizes | Phone and tablet widths | No clipping/overflow; grid uses 2 columns on phones and 4 when wide | Not executed | Not Run | — |
| TC_SECURITY_001 | REQ-SEC-01 | Two Firebase users | Create data as A; attempt reads/writes as B | Accounts A and B | Firestore and Storage reject cross-user access | Not executed | Not Run | — |
| TC_LIFECYCLE_001 | REQ-MOBILE-01 | Signed-in app | Background, resume, rotate, kill, relaunch | Standard lifecycle | State remains consistent and app does not crash | Not executed | Not Run | — |
