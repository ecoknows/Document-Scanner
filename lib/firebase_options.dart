// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDoQV1SUyuHt3ML4gEOY1Odm0d-B9gwvOI',
    appId: '1:168561166396:web:3fba862448e80a52171b39',
    messagingSenderId: '168561166396',
    projectId: 'document-scanner-35bdb',
    authDomain: 'document-scanner-35bdb.firebaseapp.com',
    storageBucket: 'document-scanner-35bdb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcSLHzg-Je1SG0QmU5lVrrw4UjQ_kW7OQ',
    appId: '1:168561166396:android:73380941f7b8f2a4171b39',
    messagingSenderId: '168561166396',
    projectId: 'document-scanner-35bdb',
    storageBucket: 'document-scanner-35bdb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGycwAVh9noGNvLRXT1sB2axbBqYOhoho',
    appId: '1:168561166396:ios:fc900b9bf8c3416f171b39',
    messagingSenderId: '168561166396',
    projectId: 'document-scanner-35bdb',
    storageBucket: 'document-scanner-35bdb.appspot.com',
    iosBundleId: 'com.example.documentScanner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGycwAVh9noGNvLRXT1sB2axbBqYOhoho',
    appId: '1:168561166396:ios:ea23bf7b1beedec3171b39',
    messagingSenderId: '168561166396',
    projectId: 'document-scanner-35bdb',
    storageBucket: 'document-scanner-35bdb.appspot.com',
    iosBundleId: 'com.example.documentScanner.RunnerTests',
  );
}
