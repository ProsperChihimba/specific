import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _contact = 'Unknown';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter is Awesome'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Picker'),
                onPressed: () => _getAContact(),
              ),
              Text(_contact ?? '')
            ],
          ),
        ),
      ),
    );
  }

  _getAContact() async {
    String contact;
    try {
      contact = await FlutterIsAwesome.getAContact();
    } on PlatformException {
      contact = 'Failed to get contact.';
    }
    if (!mounted) return;
    setState(() {
      _contact = contact;
    });
  }
}

class FlutterIsAwesome {
  static const MethodChannel _channel = MethodChannel('com.prosper.specific');
  static Future<String> getAContact() async {
    final String contact = await _channel.invokeMethod('getAContact');
    return contact;
  }
}
