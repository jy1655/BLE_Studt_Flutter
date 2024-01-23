import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

// BLE(Bluetooth Low Energy) 주변장치 기능을 제공하는 앱의 UI를 구성

class FlutterBlePeripheralExample extends StatefulWidget {
  const FlutterBlePeripheralExample({Key? key}) : super(key: key);

  @override
  FlutterBlePeripheralExampleState createState() =>
      FlutterBlePeripheralExampleState();
}

class FlutterBlePeripheralExampleState
// 광고 데이터 설정
// 이 데이터는 BLE 광고 시 사용

    extends State<FlutterBlePeripheralExample> {
  final AdvertiseData advertiseData = AdvertiseData(
    serviceUuid: '44277344-4444-4477-7777-278767970777',
    localName: 'BLESTUDYTEST',
    manufacturerId: 1234,
    manufacturerData: Uint8List.fromList([1, 2, 3, 4, 5, 6]),
  );

  
  // final advertiseSettings = AdvertiseSettings(
  //   advertiseMode: AdvertiseMode.advertiseModeBalanced,
  //   txPowerLevel: AdvertiseTxPower.advertiseTxPowerMedium,
  //   timeout: 3000,
  // );

  // 광고 파라미터 설정
  // 이 파라미터는 BLE 광고의 세부 설정을 정의합니다.
  final AdvertiseSetParameters advertiseSetParameters = AdvertiseSetParameters();

  // BLE 지원 여부를 저장하는 함수
  bool _isSupported = false;

  // initState 메소드
  // 위젯이 생성될 때 호출되며, 여기서 플랫폼 상태를 초기화합니다.
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // 플랫폼 상태 초기화
  // BLE 기능이 지원되는지 확인합니다.
  Future<void> initPlatformState() async {
    final isSupported = await FlutterBlePeripheral().isSupported;
    setState(() {
      _isSupported = isSupported;
    });
  }

  // BLE 광고를 시작하는 메소드
Future<void> _startAdvertising() async {
  await FlutterBlePeripheral().start(
    advertiseData: advertiseData,
    advertiseSetParameters: advertiseSetParameters,
  );
}

// BLE 광고를 중지하는 메소드
Future<void> _stopAdvertising() async {
  await FlutterBlePeripheral().stop();
}

  // 광고 토글 메소드
  // 현재 광고 중이면 중지하고, 그렇지 않으면 광고를 시작합니다.
  Future<void> _toggleAdvertiseSet() async {
    if (await FlutterBlePeripheral().isAdvertising) {
      await FlutterBlePeripheral().stop();
    } else {
      await FlutterBlePeripheral().start(
        advertiseData: advertiseData,
        advertiseSetParameters: advertiseSetParameters,
      );
    }
  }

  // 권한 요청 메소드
  // BLE 사용 권한을 요청합니다.
  Future<void> _requestPermissions() async {
    final hasPermission = await FlutterBlePeripheral().hasPermission();
    switch (hasPermission) {
      case BluetoothPeripheralState.denied:
        _messangerKey.currentState?.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "We don't have permissions, requesting now!",
            ),
          ),
        );

        await _requestPermissions();
        break;
      default:
        _messangerKey.currentState?.showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'State: $hasPermission!',
            ),
          ),
        );
        break;
    }
  }

  // 권한 확인 메소드
  // BLE 사용 권한이 있는지 확인합니다.
  Future<void> _hasPermissions() async {
    final hasPermissions = await FlutterBlePeripheral().hasPermission();
    _messangerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Has permission: $hasPermissions'),
        backgroundColor: hasPermissions == BluetoothPeripheralState.granted
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  // ScaffoldMessenger의 키
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  // build 메소드
  // UI를 구성하는 메소드입니다.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter BLE Peripheral'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // BLE 지원 여부를 표시합니다.
              Text('Is supported: $_isSupported'),
              // BLE 광고 상태를 스트림을 통해 실시간으로 표시합니다.
              StreamBuilder(
                stream: FlutterBlePeripheral().onPeripheralStateChanged,
                initialData: PeripheralState.unknown,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Text(
                    'State: ${(snapshot.data as PeripheralState).name}',
                  );
                },
              ),
              // StreamBuilder(
              //     stream: FlutterBlePeripheral().getDataReceived(),
              //     initialData: 'None',
              //     builder:
              //         (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              //       return Text('Data received: ${snapshot.data}');
              //     },),

              // 광고 데이터와 UUID를 표시합니다. 
              Text('Current UUID: ${advertiseData.serviceUuid}'),
              // 광고 시작/중지 버튼입니다.
              MaterialButton(
                onPressed: _startAdvertising,
                child: Text(
                  'Toggle advertising',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  await FlutterBlePeripheral().start(
                    advertiseData: advertiseData,
                    advertiseSetParameters: advertiseSetParameters,
                  );
                },
                child: Text(
                  'Start advertising',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  await FlutterBlePeripheral().stop();
                },
                child: Text(
                  'Stop advertising',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: _toggleAdvertiseSet,
                child: Text(
                  'Toggle advertising set for 1 second',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              StreamBuilder(
                stream: FlutterBlePeripheral().onPeripheralStateChanged,
                initialData: PeripheralState.unknown,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<PeripheralState> snapshot,
                ) {
                  return MaterialButton(
                    onPressed: () async {
                      final bool enabled = await FlutterBlePeripheral()
                          .enableBluetooth(askUser: false);
                      if (enabled) {
                        _messangerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Bluetooth enabled!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        _messangerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Bluetooth not enabled!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Enable Bluetooth (ANDROID)',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelLarge!
                          .copyWith(color: Colors.blue),
                    ),
                  );
                },
              ),
              MaterialButton(
                onPressed: () async {
                  final bool enabled =
                      await FlutterBlePeripheral().enableBluetooth();
                  if (enabled) {
                    _messangerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Bluetooth enabled!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    _messangerKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Bluetooth not enabled!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  'Ask if enable Bluetooth (ANDROID)',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: _requestPermissions,
                child: Text(
                  'Request Permissions',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: _hasPermissions,
                child: Text(
                  'Has permissions',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
              MaterialButton(
                onPressed: () => FlutterBlePeripheral().openBluetoothSettings(),
                child: Text(
                  'Open bluetooth settings',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .labelLarge!
                      .copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}