// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNOS-ZY0GYMWiFY4QbQDBONTCPhmTzBUc',
    appId: '1:220539958835:web:5df52286a677b8f761d546',
    messagingSenderId: '220539958835',
    projectId: 'compliscan-38a6d',
    authDomain: 'compliscan-38a6d.firebaseapp.com',
    storageBucket: 'compliscan-38a6d.firebasestorage.app',
    measurementId: 'G-L1PZQDK08Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNOS-ZY0GYMWiFY4QbQDBONTCPhmTzBUc',
    appId:
        '1:220539958835:android:YOUR_ANDROID_APP_ID', // You'll need to add Android app for this
    messagingSenderId: '220539958835',
    projectId: 'compliscan-38a6d',
    storageBucket: 'compliscan-38a6d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNOS-ZY0GYMWiFY4QbQDBONTCPhmTzBUc',
    appId:
        '1:220539958835:ios:YOUR_IOS_APP_ID', // You'll need to add iOS app for this
    messagingSenderId: '220539958835',
    projectId: 'compliscan-38a6d',
    storageBucket: 'compliscan-38a6d.firebasestorage.app',
    iosBundleId: 'com.example.sih',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNOS-ZY0GYMWiFY4QbQDBONTCPhmTzBUc',
    appId:
        '1:220539958835:ios:YOUR_MACOS_APP_ID', // You'll need to add macOS app for this
    messagingSenderId: '220539958835',
    projectId: 'compliscan-38a6d',
    storageBucket: 'compliscan-38a6d.firebasestorage.app',
    iosBundleId: 'com.example.sih',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNOS-ZY0GYMWiFY4QbQDBONTCPhmTzBUc',
    appId:
        '1:220539958835:web:5df52286a677b8f761d546', // Using web config for Windows
    messagingSenderId: '220539958835',
    projectId: 'compliscan-38a6d',
    authDomain: 'compliscan-38a6d.firebaseapp.com',
    storageBucket: 'compliscan-38a6d.firebasestorage.app',
  );
}
