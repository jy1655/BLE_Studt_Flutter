import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const FlutterBlueApp());
}

class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Blue Example'),
        ),
        body: _adapterState == BluetoothAdapterState.on
            ? const ScanScreen()
            : BluetoothOffScreen(adapterState: _adapterState),
      ),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothAdapterState adapterState;

  const BluetoothOffScreen({Key? key, required this.adapterState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bluetooth is OFF. Adapter state: $adapterState'),
    );
  }
}

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Scanning for Bluetooth devices...'),
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
      if (state != BluetoothAdapterState.on) {
        navigator?.pop();
      }
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
