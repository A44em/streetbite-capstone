# R8 keep rules for release builds.
#
# shared_preferences_android calls SharedPreferencesApiRegistrar methods through
# JNI. R8 removed them, so the release app crashed at startup with
# NoSuchMethodError (DEF-APP-004).
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# The JNI bindings resolve Kotlin stdlib types by name (kotlin.coroutines.Continuation,
# kotlin.Result, ...). R8 renamed or removed them (e.g. Continuation -> u6.c), so
# lookups failed. Keep the Kotlin stdlib and the jni runtime intact.
-keep class kotlin.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
