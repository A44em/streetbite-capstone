# GUI Test Suite

The canonical steps and result fields are maintained in `TEST_CASES.md`.

| Case IDs | Coverage |
|---|---|
| TC_ONBOARD_001 | Branding, animation, spacing, first-run layout |
| TC_LOGIN_001–003 | Form layout, focus, validation, loading and error states |
| TC_HOME_001–003 | Featured PageView, offers, grid, loading/empty/error states |
| TC_MEAL_001 | Image scaling, metadata hierarchy, long-instruction scrolling |
| TC_CART_001–002 | Item layout, totals, payment control, empty state, SnackBar |
| TC_MAP_001 | Map viewport, markers, info-window readability |
| TC_PROFILE_001–004 | Avatar, progress, sections, long device information |
| TC_LOCALE_001 | Arabic text, RTL order, mirroring, truncation |
| TC_THEME_001 | Contrast, surfaces, controls, images in both themes |
| TC_RESPONSIVE_001 | Phone/tablet breakpoints and overflow |

Executed 2026-10-20 on the API 36 emulator (phone 1080×2400, emulated tablet 1600×2560): all
GUI cases Pass except TC_MAP_001 (Blocked, no Maps key) and TC_PROFILE_003 (Blocked live; photo
upload verified on the Emulator Suite). Evidence is linked per case in `TEST_CASES.md`.
