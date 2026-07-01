-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver { *; }

# Keep GSON classes used by flutter_local_notifications for serialization
-keep class com.google.gson.** { *; }
-keepclassmembers class com.google.gson.** { *; }

# Keep desugared java.time classes to prevent timezone crashes in release
-keep class java.time.** { *; }
-keep class j$.time.** { *; }
