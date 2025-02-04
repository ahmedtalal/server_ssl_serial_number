import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'server_ssl_serial_platform_interface.dart';

/// An implementation of [ServerSslSerialPlatform] that uses method channels.
class MethodChannelServerSslSerial extends ServerSslSerialPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('server_ssl_serial');

  @override
  Future<String?> getServerSerialNumber(String serverUrl) async {
    final version = await methodChannel
        .invokeMethod<String>('getServerSerialNumber', {"url": serverUrl});
    return version;
  }
}
