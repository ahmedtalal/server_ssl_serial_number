import 'server_ssl_serial_platform_interface.dart';

class ServerSslSerial {
  /// Returns the server serial number from the platform
  Future<String?> getServerSerialNumber(String serverUrl) {
    return ServerSslSerialPlatform.instance.getServerSerialNumber(serverUrl);
  }
}
