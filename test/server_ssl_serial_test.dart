import 'package:flutter_test/flutter_test.dart';
import 'package:server_ssl_serial/server_ssl_serial.dart';
import 'package:server_ssl_serial/server_ssl_serial_platform_interface.dart';
import 'package:server_ssl_serial/server_ssl_serial_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockServerSslSerialPlatform
    with MockPlatformInterfaceMixin
    implements ServerSslSerialPlatform {
  @override
  Future<String?> getServerSerialNumber(String serverUrl) {
    return Future.value("2996883961D8D4DC117E3625FC285CAA");
  }
}

void main() {
  final ServerSslSerialPlatform initialPlatform =
      ServerSslSerialPlatform.instance;

  test('$MethodChannelServerSslSerial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelServerSslSerial>());
  });

  test('getPlatformVersion', () async {
    ServerSslSerial serverSslSerialPlugin = ServerSslSerial();
    MockServerSslSerialPlatform fakePlatform = MockServerSslSerialPlatform();
    ServerSslSerialPlatform.instance = fakePlatform;

    expect(
        await serverSslSerialPlugin
            .getServerSerialNumber("https://jsonplaceholder.typicode.com/"),
        '2996883961D8D4DC117E3625FC285CAA');
  });
}
