import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'server_ssl_serial_method_channel.dart';

abstract class ServerSslSerialPlatform extends PlatformInterface {
  /// Constructs a ServerSslSerialPlatform.
  ServerSslSerialPlatform() : super(token: _token);

  static final Object _token = Object();

  static ServerSslSerialPlatform _instance = MethodChannelServerSslSerial();

  /// The default instance of [ServerSslSerialPlatform] to use.
  ///
  /// Defaults to [MethodChannelServerSslSerial].
  static ServerSslSerialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ServerSslSerialPlatform] when
  /// they register themselves.
  static set instance(ServerSslSerialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getServerSerialNumber(String serverUrl) {
    throw UnimplementedError(
        'getServerSerialNumber() has not been implemented.');
  }
}
