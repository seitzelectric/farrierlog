# The Flutter Gradle plugin already keeps the engine/embedding and
# GeneratedPluginRegistrant classes; these rules cover the app's own
# plugins beyond that default.

# sqflite loads its native SQLite bindings and driver classes by name.
-keep class com.tekartik.sqflite.** { *; }

# printing/pdf and file_picker reflect over their platform-channel classes.
-keep class net.nfet.flutter.printing.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# package:jni (used transitively for native bindings) resolves classes by
# name via JNI, which R8 can't see as a usage.
-keep class dev.dart.jni.** { *; }
-keepclassmembers class * {
    @dev.dart.jni.* *;
}

# Keep annotations and generic signatures needed by reflection-based
# libraries (plugin method channels, platform view registration, etc).
-keepattributes Signature,*Annotation*,EnclosingMethod,InnerClasses

# Keep native method names since obfuscating them breaks JNI lookups.
-keepclasseswithmembernames class * {
    native <methods>;
}
