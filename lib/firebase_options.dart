// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDnPk5IcHTjRNZ_65mH1I-aM7-CVkgkeRY',
    appId: '1:408678428729:web:fff3c78e24c0ed6468dde8',
    messagingSenderId: '408678428729',
    projectId: 'eventhub-map4',
    authDomain: 'eventhub-map4.firebaseapp.com',
    storageBucket: 'eventhub-map4.appspot.com',
    measurementId: 'G-5WKKJYJ6PB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCs1VzJ9Ps3tkry9plsTYgl_jO2wZkxSZI',
    appId: '1:408678428729:android:2cd29a5c31c34b8568dde8',
    messagingSenderId: '408678428729',
    projectId: 'eventhub-map4',
    storageBucket: 'eventhub-map4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFqpZJqVf8znQVbSoDlYpg07N4K8Aq_0E',
    appId: '1:408678428729:ios:aafcf92922c59be868dde8',
    messagingSenderId: '408678428729',
    projectId: 'eventhub-map4',
    storageBucket: 'eventhub-map4.appspot.com',
    iosBundleId: 'com.example.eventhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFqpZJqVf8znQVbSoDlYpg07N4K8Aq_0E',
    appId: '1:408678428729:ios:aafcf92922c59be868dde8',
    messagingSenderId: '408678428729',
    projectId: 'eventhub-map4',
    storageBucket: 'eventhub-map4.appspot.com',
    iosBundleId: 'com.example.eventhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDnPk5IcHTjRNZ_65mH1I-aM7-CVkgkeRY',
    appId: '1:408678428729:web:3e6d15bd1a486b4d68dde8',
    messagingSenderId: '408678428729',
    projectId: 'eventhub-map4',
    authDomain: 'eventhub-map4.firebaseapp.com',
    storageBucket: 'eventhub-map4.appspot.com',
    measurementId: 'G-D7SEMV7M7N',
  );
}
