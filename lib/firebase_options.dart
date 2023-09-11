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
    apiKey: 'AIzaSyDg23B8nvnX0-dlqvwaqQV2BH3Qu42vjVA',
    appId: '1:572776334786:web:d159133aaa8ac8e95f425b',
    messagingSenderId: '572776334786',
    projectId: 'notes-module-lvl-up-app',
    authDomain: 'notes-module-lvl-up-app.firebaseapp.com',
    storageBucket: 'notes-module-lvl-up-app.appspot.com',
    measurementId: 'G-GCRKN57KXL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBU8yFX5AEq7VTecm_lCo7NF5kkAci5I1g',
    appId: '1:572776334786:android:bf1f2afcd864fa395f425b',
    messagingSenderId: '572776334786',
    projectId: 'notes-module-lvl-up-app',
    storageBucket: 'notes-module-lvl-up-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXeFeZWDyxe2IpVe1eOlBoO5TrCpCia60',
    appId: '1:572776334786:ios:f6b767867b7644865f425b',
    messagingSenderId: '572776334786',
    projectId: 'notes-module-lvl-up-app',
    storageBucket: 'notes-module-lvl-up-app.appspot.com',
    iosClientId: '572776334786-28v1ook2b2ngc2djht45b4214nme3ls9.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXeFeZWDyxe2IpVe1eOlBoO5TrCpCia60',
    appId: '1:572776334786:ios:530730b32da3fa635f425b',
    messagingSenderId: '572776334786',
    projectId: 'notes-module-lvl-up-app',
    storageBucket: 'notes-module-lvl-up-app.appspot.com',
    iosClientId: '572776334786-p9m86hd1760phav8mrbri96h3m92bci9.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes.RunnerTests',
  );
}