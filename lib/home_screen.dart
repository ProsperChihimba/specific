import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _batteryLevel = 'Unknown battery level.';
  static const platform = MethodChannel('com.prosper.specific');

  Future<void> _getBatteryLevel() async {
    // String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getAContact');
      // batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      // batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    // setState(() {
    //   _batteryLevel = batteryLevel;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Your battery level is ${_batteryLevel}'),
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
        ],
      ),
    );
  }
}
