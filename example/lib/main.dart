import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:server_ssl_serial/server_ssl_serial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _serverSerialNumber = 'Unknown';
  final _serverSslSerialPlugin = ServerSslSerial();

  @override
  void initState() {
    super.initState();
    getServerSerialNumber();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getServerSerialNumber() async {
    String serverSerialNumber;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      serverSerialNumber = await _serverSslSerialPlugin
              .getServerSerialNumber("https://jsonplaceholder.typicode.com/") ??
          'Failed to get server serial number';
    } on PlatformException {
      serverSerialNumber = 'Failed to get server serial number.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _serverSerialNumber = serverSerialNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_serverSerialNumber'),
        ),
      ),
    );
  }
}
