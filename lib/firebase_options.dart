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
    apiKey: 'AIzaSyABLs-f36bIJIJnvJpXOAb77tcM38fVyf0',
    appId: '1:593962406148:web:44daca98d3db300677c051',
    messagingSenderId: '593962406148',
    projectId: 'gdscvit-icebreaker-hack',
    authDomain: 'gdscvit-icebreaker-hack.firebaseapp.com',
    storageBucket: 'gdscvit-icebreaker-hack.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCH5M7ukhzc8FxCq-pN3i71PW5oeSNt6TY',
    appId: '1:593962406148:android:03830ec6de7613bf77c051',
    messagingSenderId: '593962406148',
    projectId: 'gdscvit-icebreaker-hack',
    storageBucket: 'gdscvit-icebreaker-hack.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvo35DIGA21e_rkG4X5jIsRGlsm8iMWi8',
    appId: '1:593962406148:ios:7608fc9ae1132f1a77c051',
    messagingSenderId: '593962406148',
    projectId: 'gdscvit-icebreaker-hack',
    storageBucket: 'gdscvit-icebreaker-hack.appspot.com',
    androidClientId: '593962406148-fugta77dl59pvk46mc9qsu2rus7t3u1j.apps.googleusercontent.com',
    iosClientId: '593962406148-kfd8t0ompb50fk5kijqaeedrmj5nscd2.apps.googleusercontent.com',
    iosBundleId: 'me.chandramdutta.gdscvitIcebreaker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvo35DIGA21e_rkG4X5jIsRGlsm8iMWi8',
    appId: '1:593962406148:ios:f368a3925c6359b577c051',
    messagingSenderId: '593962406148',
    projectId: 'gdscvit-icebreaker-hack',
    storageBucket: 'gdscvit-icebreaker-hack.appspot.com',
    androidClientId: '593962406148-fugta77dl59pvk46mc9qsu2rus7t3u1j.apps.googleusercontent.com',
    iosClientId: '593962406148-qtfcgkraq63hdr52iobeeqls2rd119rs.apps.googleusercontent.com',
    iosBundleId: 'me.chandramdutta.gdscvitIcebreaker.RunnerTests',
  );
}
