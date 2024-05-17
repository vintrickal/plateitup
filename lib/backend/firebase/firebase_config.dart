import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAAHfDVgIxu0nxjeF3KvvTQg7UChWSO8zk",
            authDomain: "plateitup-89054.firebaseapp.com",
            projectId: "plateitup-89054",
            storageBucket: "plateitup-89054.appspot.com",
            messagingSenderId: "962369962598",
            appId: "1:962369962598:web:3517e23e6cf251418ae3a7"));
  } else {
    await Firebase.initializeApp();
  }
}
