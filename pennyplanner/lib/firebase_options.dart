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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
      apiKey: "AIzaSyDVMkwxuQtpaFev831PytJkyFBSYl-nEqk",
      authDomain: "pennyplanner-c424c.firebaseapp.com",
      databaseURL: "https://pennyplanner-c424c-default-rtdb.europe-west1.firebasedatabase.app/",
      projectId: "pennyplanner-c424c",
      storageBucket: "pennyplanner-c424c.appspot.com",
      messagingSenderId: "67687043326",
      appId: "1:67687043326:web:9b134a52149c4fe23b95af",
      measurementId: "G-R4YBGTHM9T"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUbP-kHPVZJNJw48fy5RJA3VP-N9xhh2k',
    appId: '1:67687043326:android:07dc72824d7177c83b95af',
    messagingSenderId: '67687043326',
    projectId: 'pennyplanner-c424c',
    storageBucket: 'pennyplanner-c424c.appspot.com',
  );
}
