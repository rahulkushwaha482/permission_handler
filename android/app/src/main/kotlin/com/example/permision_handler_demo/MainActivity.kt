package com.example.permision_handler_demo

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(){
    private val CHANNEL = "sample.android.sdk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "getSdkLevel" -> { // Ensure the method name matches
                    val version = Build.VERSION.SDK_INT
                    println("API Lelel :$version")
                    result.success(version)  // Send the version back to Flutter
                }
                else -> {
                    result.notImplemented() // Handle unimplemented methods
                }
            }
        }

    }
}
