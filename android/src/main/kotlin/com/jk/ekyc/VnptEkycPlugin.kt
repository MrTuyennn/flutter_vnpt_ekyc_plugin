package com.jk.ekyc

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import com.vnptit.idg.sdk.activity.VnptFrontActivity
import com.vnptit.idg.sdk.activity.VnptIdentityActivity
import com.vnptit.idg.sdk.activity.VnptOcrActivity
import com.vnptit.idg.sdk.activity.VnptPortraitActivity
import com.vnptit.idg.sdk.activity.VnptQRCodeActivity
import com.vnptit.idg.sdk.activity.VnptRearActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class VnptEkycPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener,
    PluginRegistry.RequestPermissionsResultListener {

    private lateinit var channel: MethodChannel
    private var binding: ActivityPluginBinding? = null
    private var pendingResult: Result? = null
    private var pendingIntent: Intent? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_vnpt_ekyc_plugin",
        )
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) = attach(binding)
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = attach(binding)
    override fun onDetachedFromActivityForConfigChanges() = detach(permanent = false)
    override fun onDetachedFromActivity() = detach(permanent = true)

    private fun attach(newBinding: ActivityPluginBinding) {
        binding = newBinding
        newBinding.addActivityResultListener(this)
        newBinding.addRequestPermissionsResultListener(this)
    }

    private fun detach(permanent: Boolean) {
        binding?.removeActivityResultListener(this)
        binding?.removeRequestPermissionsResultListener(this)
        binding = null
        if (permanent) {
            finish { it.error("activity_detached", "The host Activity was detached before the eKYC flow completed.", null) }
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method != "start") {
            result.notImplemented()
            return
        }
        val activity = binding?.activity
        if (activity == null) {
            result.error("no_activity", "The plugin is not attached to an Activity.", null)
            return
        }
        if (pendingResult != null) {
            result.error("already_running", "An eKYC flow is already in progress.", null)
            return
        }

        val intent = try {
            EkycIntentFactory.build(
                activity,
                call.argument<String>("flow"),
                call.argument<Map<String, Any?>>("config"),
            )
        } catch (e: IllegalArgumentException) {
            result.error("invalid_argument", e.message, null)
            return
        }

        pendingResult = result
        pendingIntent = intent
        if (activity.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            launch(activity)
        } else {
            activity.requestPermissions(arrayOf(Manifest.permission.CAMERA), REQUEST_CAMERA)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode != REQUEST_CAMERA) return false
        val activity = binding?.activity
        if (activity != null && grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
            launch(activity)
        } else {
            finish { it.error("camera_permission_denied", "Camera permission was denied.", null) }
        }
        return true
    }

    private fun launch(activity: Activity) {
        val intent = pendingIntent ?: return
        try {
            activity.startActivityForResult(intent, REQUEST_EKYC)
        } catch (e: Exception) {
            finish { it.error("sdk_error", e.message, null) }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_EKYC) return false
        finish { it.success(EkycResultMapper.toMap(resultCode, data)) }
        return true
    }

    private inline fun finish(reply: (Result) -> Unit) {
        val result = pendingResult
        pendingResult = null
        pendingIntent = null
        if (result != null) reply(result)
    }

    companion object {
        private const val REQUEST_EKYC = 0x7E01
        private const val REQUEST_CAMERA = 0x7E02

        internal fun activityFor(flow: String?): Class<out Activity> = when (flow) {
            "full" -> VnptIdentityActivity::class.java
            "ocr" -> VnptOcrActivity::class.java
            "ocrFront" -> VnptFrontActivity::class.java
            "ocrBack" -> VnptRearActivity::class.java
            "face" -> VnptPortraitActivity::class.java
            "qrCode" -> VnptQRCodeActivity::class.java
            else -> throw IllegalArgumentException("Unknown flow: $flow")
        }
    }
}
