import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class ConfigFirebaseConfig {
  static FirebaseOptions get platformOptions {
    /*   if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        appId: '1:1021349151297:android:a1087dc154159c155bbcc0',
        apiKey: 'AIzaSyBCVJ8fSsqRTt9o5tzMBjpyFr1-87vEre4',
        projectId: 'keep-sake-ade93',
        messagingSenderId: '1021349151297',
      );
    } else*/
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:357674854436:android:802ebc4a147ff043fe10b1',
        apiKey: 'AIzaSyBgfiCHo0GFz5GHkKUQej01t1EPFjl7Twk',
        projectId: 'civic-eye-cb118',
        messagingSenderId: '300304976515',
        // iosClientId:
        //     "676243840644-hmvpvru9n9oqjv64r19gbiprfnfv7dh7.apps.googleusercontent.com",
        storageBucket: "civic-eye-cb118.appspot.com",
        iosBundleId: "com.gologonow.civiceye",
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:549725868575:android:b537348a10ef4d7c687b2a',
        apiKey: 'AIzaSyC7UUbIq1eM5CHfwffzsKdC6t8ILIdDQKY',
        projectId: 'com.gologonow.groovkinn',
        messagingSenderId: '549725868575',
        storageBucket: "groovkin-a2676.appspot.com",
      );
    }
  }
}
