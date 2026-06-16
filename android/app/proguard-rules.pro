# Flutter / plugins generally ship their own consumer ProGuard rules.
# A few extra keeps for safety with R8 full mode.

# Google ML Kit face detection
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_face.** { *; }
-dontwarn com.google.mlkit.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Play Core (used by Flutter deferred components / in_app_review)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep annotations
-keepattributes *Annotation*
