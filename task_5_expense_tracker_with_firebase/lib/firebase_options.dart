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
    apiKey: 'AIzaSyDtQCv7xd11O-rVT7PfMpkrnmdpYO6q42U',
    appId: '1:415399539658:web:cee1a2b3efa3edcdccd533',
    messagingSenderId: '415399539658',
    projectId: 'expensemanager-68319',
    authDomain: 'expensemanager-68319.firebaseapp.com',
    storageBucket: 'expensemanager-68319.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTI3rfOGTKUT2EysvhQibn_zpX39KZsOc',
    appId: '1:415399539658:android:787e6dc9b8c996a3ccd533',
    messagingSenderId: '415399539658',
    projectId: 'expensemanager-68319',
    storageBucket: 'expensemanager-68319.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwTDQueHM_mjXAgivj1EARqJcVySQ1Nkc',
    appId: '1:415399539658:ios:142525691adc057eccd533',
    messagingSenderId: '415399539658',
    projectId: 'expensemanager-68319',
    storageBucket: 'expensemanager-68319.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwTDQueHM_mjXAgivj1EARqJcVySQ1Nkc',
    appId: '1:415399539658:ios:142525691adc057eccd533',
    messagingSenderId: '415399539658',
    projectId: 'expensemanager-68319',
    storageBucket: 'expensemanager-68319.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDtQCv7xd11O-rVT7PfMpkrnmdpYO6q42U',
    appId: '1:415399539658:web:c408f0a712c946a9ccd533',
    messagingSenderId: '415399539658',
    projectId: 'expensemanager-68319',
    authDomain: 'expensemanager-68319.firebaseapp.com',
    storageBucket: 'expensemanager-68319.appspot.com',
  );
}