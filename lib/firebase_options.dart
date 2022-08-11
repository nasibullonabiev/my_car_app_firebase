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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCB_TTdA8X5jaPBTQ9XcFQarbsWiktJZrc',
    appId: '1:659255109078:web:cb2ab7e6116bdc98397077',
    messagingSenderId: '659255109078',
    projectId: 'my-car-app-52e4f',
    authDomain: 'my-car-app-52e4f.firebaseapp.com',
    storageBucket: 'my-car-app-52e4f.appspot.com',
    measurementId: 'G-1P5W0DQYE8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4PB5r-aRotUeWRw-zBUyvGcrhRkuuDKc',
    appId: '1:659255109078:android:6bbde50ed2fd6349397077',
    messagingSenderId: '659255109078',
    projectId: 'my-car-app-52e4f',
    storageBucket: 'my-car-app-52e4f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUjD1DDiiW3HqjOZjzk-M0hSP5ZTVBptk',
    appId: '1:659255109078:ios:5d0a444b28a94054397077',
    messagingSenderId: '659255109078',
    projectId: 'my-car-app-52e4f',
    storageBucket: 'my-car-app-52e4f.appspot.com',
    iosClientId: '659255109078-vnlapkor9mkiqic15gane58dcc54c29a.apps.googleusercontent.com',
    iosBundleId: 'com.example.myCarAppFirebase',
  );
}
