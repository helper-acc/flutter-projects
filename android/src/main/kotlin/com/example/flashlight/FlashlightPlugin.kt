package com.example.flashlight

import android.content.Context
import android.hardware.camera2.CameraManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlashlightPlugin */
class FlashlightPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var cameraManager: CameraManager
    private var cameraId: String? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
        channel.setMethodCallHandler(this)

        cameraManager =
            flutterPluginBinding.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        cameraId = cameraManager.cameraIdList.find { id ->
            cameraManager.getCameraCharacteristics(id)
                .get(android.hardware.camera2.CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "toggleLight" -> {
                val isOn = call.argument<Boolean>("isOn") ?: false
                toggleFlashlight(isOn)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun toggleFlashlight(isOn: Boolean) {
        cameraId?.let {
            cameraManager.setTorchMode(it, isOn)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
