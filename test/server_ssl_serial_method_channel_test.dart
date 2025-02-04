import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:server_ssl_serial/server_ssl_serial_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelServerSslSerial platform = MethodChannelServerSslSerial();
  const MethodChannel channel = MethodChannel('server_ssl_serial');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(
        await platform
            .getServerSerialNumber("https://jsonplaceholder.typicode.com/"),
        '2996883961D8D4DC117E3625FC285CAA');
  });
}
