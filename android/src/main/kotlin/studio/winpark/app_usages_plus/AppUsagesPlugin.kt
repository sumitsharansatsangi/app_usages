package studio.winpark.app_usages_plus

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AppUsagesPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private val interval = UsageStatsManager.INTERVAL_DAILY

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "app_usages_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "getAppUsageStats" -> {
        val args = call.arguments as Map<*, *>
        val startDate = args["startDate"] as Long
        val endDate = args["endDate"] as Long
        val packageNames = args["packageNames"] as? List<String> // Nullable list of package names
        result.success(getAppUsageStats(startDate, endDate, packageNames))
      }

      "openUsageAccessSettings" -> {
        openUsageAccessSettings()
        result.success(null)
      }

      else -> result.notImplemented()
    }
  }


  private fun getAppUsageStats(startDate: Long, endDate: Long, packageNames: List<String>?): List<Map<String, Any>> {
    val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    val usageStats = usageStatsManager.queryUsageStats(interval, startDate, endDate)

    if (usageStats == null || usageStats.isEmpty()) {
      return emptyList()
    }

    val packageManager = context.packageManager
    val appsList = mutableListOf<Map<String, Any>>()

    usageStats.forEach { usageStat ->
      if (usageStat.totalTimeInForeground <= 0) return@forEach
      val packageName = usageStat.packageName

      // Check if the package is in the user-provided list (if provided)
      if (packageNames != null && !packageNames.contains(packageName)) {
        return@forEach
      }

      try {
        val appInfo = packageManager.getApplicationInfo(packageName, 0)
        if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0) {
          val app = appsList.firstOrNull { it["packageName"] == packageName }
          if (app != null) {
            val usages = app["usages"] as MutableList<Map<String, Any>>
            usages.add(
              mapOf(
                "totalTimeInForeground" to usageStat.totalTimeInForeground,
                "date" to usageStat.firstTimeStamp
              )
            )
          } else {
            appsList.add(
              mapOf(
                "packageName" to packageName,
                "appLabel" to packageManager.getApplicationLabel(appInfo),
                "installTime" to getInstallTime(packageName),
                "usages" to mutableListOf(
                  mapOf(
                    "totalTimeInForeground" to usageStat.totalTimeInForeground,
                    "date" to usageStat.firstTimeStamp
                  )
                )
              )
            )
          }
        }
      } catch (e: PackageManager.NameNotFoundException) {
        Log.e("AppUsagePlugin", "Application not found: ${e.message}")
      }
    }

    return appsList
  }


  private fun getInstallTime(packageName: String): Long {
    return try {
      val packageInfo = context.packageManager.getPackageInfo(packageName, 0)
      packageInfo.firstInstallTime
    } catch (e: PackageManager.NameNotFoundException) {
      0
    }
  }

  private fun openUsageAccessSettings() {
    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    context.startActivity(intent)
  }
}
