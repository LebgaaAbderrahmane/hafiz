# ProGuard rules for Hafiz
# Add project specific ProGuard rules here.

# Keep Supabase classes
-keep class com.supabase.** { *; }

# Keep Drift classes
-keep class * extends androidx.room.RoomDatabase { *; }

# Keep Flutter plugins
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
