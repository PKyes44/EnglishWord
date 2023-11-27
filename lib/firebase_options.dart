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
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
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
    apiKey: 'AIzaSyD5LK6E-r6-CsWV7pWIwSCgvatFrNYW_r4',
    appId: '1:1058676947238:web:7380a43d88dface34929e7',
    messagingSenderId: '1058676947238',
    projectId: 'englishquiz-2c4ea',
    authDomain: 'englishquiz-2c4ea.firebaseapp.com',
    storageBucket: 'englishquiz-2c4ea.appspot.com',
    measurementId: 'G-6XSFGRW8D4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQnXZKOUiQIhXl-5E718MPGbTq2iOqPJM',
    appId: '1:1058676947238:android:5b6ca81c5541a4234929e7',
    messagingSenderId: '1058676947238',
    projectId: 'englishquiz-2c4ea',
    storageBucket: 'englishquiz-2c4ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOtc_v-CUYmXSgQdtkilqiJ2EXn4Tk-Vg',
    appId: '1:1058676947238:ios:04a5d3368233b9174929e7',
    messagingSenderId: '1058676947238',
    projectId: 'englishquiz-2c4ea',
    storageBucket: 'englishquiz-2c4ea.appspot.com',
    iosBundleId: 'com.example.englishQuiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOtc_v-CUYmXSgQdtkilqiJ2EXn4Tk-Vg',
    appId: '1:1058676947238:ios:d19d69f268931b664929e7',
    messagingSenderId: '1058676947238',
    projectId: 'englishquiz-2c4ea',
    storageBucket: 'englishquiz-2c4ea.appspot.com',
    iosBundleId: 'com.example.englishQuiz.RunnerTests',
  );
}
