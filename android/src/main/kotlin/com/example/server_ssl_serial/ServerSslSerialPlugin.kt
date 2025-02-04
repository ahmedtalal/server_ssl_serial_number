package com.example.server_ssl_serial

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URL
import javax.net.ssl.HttpsURLConnection

/** ServerSslSerialPlugin */
class ServerSslSerialPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "server_ssl_serial")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
      if (call.method == "getServerSerialNumber") {
          val url = call.argument<String>("url")
          if (url != null) {
              val serialNumber = getServerSerialNumber(url)
              if (serialNumber != null) {
                  result.success(serialNumber)
              } else {
                  result.error("UNAVAILABLE", "Serial number not available", null)
              }
          } else {
              result.error("INVALID_ARGUMENT", "URL is required", null)
          }
      } else {
          result.notImplemented()
      }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getServerSerialNumber(serverUrl: String): String? {
        return try {
            // Run network call on a background thread
            val result = kotlinx.coroutines.runBlocking {
                kotlinx.coroutines.withContext(kotlinx.coroutines.Dispatchers.IO) {
                    fetchSerialNumber(serverUrl)
                }
            }
            result
        } catch (e: Exception) {
            Log.e("SerialNumberError", "Error fetching serial number", e)
            null
        }
    }
    private fun fetchSerialNumber(serverUrl: String): String? {
        val url = URL(serverUrl)
        val connection = url.openConnection() as HttpsURLConnection
        return try {
            connection.connect()
            val certificate = connection.serverCertificates[0] as java.security.cert.X509Certificate
            certificate.serialNumber.toString(16).uppercase() // Serial number in hex
        } finally {
            connection.disconnect()
        }
    }
}
