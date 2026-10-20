# General Mobile Test Suite

The canonical mobile cases are TC_RESPONSIVE_001 and TC_LIFECYCLE_001. During
execution they are supplemented by the following checks:

- Clean install, reinstall, and upgrade from the prior build
- Portrait layout on two screen sizes and multiple text-scale settings
- Background/resume, process death, rotation, and low-memory recovery
- Offline, slow, interrupted, and restored connectivity
- Permission denied, denied permanently, and later-enabled flows
- Back navigation, keyboard dismissal, focus order, and screen-reader labels
- Battery/network usage observation during meal loading and map use
- Android 10 or later plus the project target SDK

Executed 2026-10-20 on the emulator: TC_RESPONSIVE_001 and TC_LIFECYCLE_001 Pass (two screen
profiles, rotation, background/resume, process kill, offline/restored connectivity, signed-release
install). Not covered: physical-device runs, text-scale variations and battery measurement.
