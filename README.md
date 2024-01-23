# ble_study

Bluetooth Low Energy 기능을 사용해보기 위한 테스트 프로젝트

v0.1 프로젝트 생성당시 목표는 예전에 제작한 swift로 작성된 BLEStudy 와 서로 데이터를 교환할수 있도록 하여 각자의 테스트를 용이하게 만드는것


### Dependency

pubspec.yaml 파일에 작성

- flutter_blue_plus ^1.31.8 : It supports BLE Central Role only (most common)
    (https://pub.dev/packages?q=flutter_blue)

- flutter_ble_peripheral ^1.2.3 : BLE Peripheral Role을 위한 dependency. iOS에서는 굉장히 제한적으로 사용가능
    (https://pub.dev/packages/flutter_ble_peripheral)

https://pub.dev/ 에서 버전확인


### 권한 설정

- Android(android/app/src/main/AndroidManifest.xml)
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

- iOS(ios/Runner/Info.plist)
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Your custom message for requesting Bluetooth access</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Your custom message for requesting location access</string>


### Android 설정관련 

`android/gradle/gradle-wrapper.properties` 파일에서 Gradle version 8.5로 설정

`android/app/build.gradle` 파일에서 compileSdkVersion을 34, defaultConfig 블록을 찾아 minSdkVersion을 21로 설정


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
