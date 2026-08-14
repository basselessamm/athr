package com.athr.athr

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val prayerAudioChannel = "athr/prayer_audio"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, prayerAudioChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "prayerAudioUri") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val prayer = call.argument<String>("prayer")
                if (prayer.isNullOrBlank()) {
                    result.error("INVALID_PRAYER", "Prayer name is required", null)
                    return@setMethodCallHandler
                }
                val resourceId = resources.getIdentifier(
                    "prayer_$prayer",
                    "raw",
                    packageName,
                )
                if (resourceId == 0) {
                    result.error(
                        "MISSING_PRAYER_AUDIO",
                        "Missing local prayer audio resource for $prayer",
                        null,
                    )
                    return@setMethodCallHandler
                }
                result.success("android.resource://$packageName/$resourceId")
            }
    }
}
