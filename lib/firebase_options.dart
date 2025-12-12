import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyDr5EmvleR_OofQkThEvRT_LGwaCN9y7oo",
        authDomain: "autism-screening-66c19.firebaseapp.com",
        projectId: "autism-screening-66c19",
        storageBucket: "autism-screening-66c19.firebasestorage.app",
        messagingSenderId: "986929755468",
        appId: "1:986929755468:web:562b52370f9399c999cbe9",
        measurementId: "G-2WBE5WY8VS",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDr5EmvleR_OofQkThEvRT_LGwaCN9y7oo',
          appId: '1:986929755468:android:1b4b61f7f7ed550599cbe9',
          messagingSenderId: '986929755468',
          projectId: 'autism-screening-66c19',
          storageBucket: 'autism-screening-66c19.firebasestorage.app',
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_APPLE_API_KEY',
          appId: 'YOUR_APPLE_APP_ID',
          messagingSenderId: 'YOUR_APPLE_MESSAGING_SENDER_ID',
          projectId: 'YOUR_APPLE_PROJECT_ID',
          storageBucket: 'YOUR_APPLE_STORAGE_BUCKET',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'YOUR_DESKTOP_API_KEY',
          appId: 'YOUR_DESKTOP_APP_ID',
          messagingSenderId: 'YOUR_DESKTOP_MESSAGING_SENDER_ID',
          projectId: 'YOUR_DESKTOP_PROJECT_ID',
          storageBucket: 'YOUR_DESKTOP_STORAGE_BUCKET',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
