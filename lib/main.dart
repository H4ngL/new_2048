import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_2048/firebase/firebase_auth.dart';
import 'package:new_2048/firebase/googleSignIn.dart';
import 'package:new_2048/screens/auth_screen.dart';
import 'package:new_2048/firebase_options.dart';
import 'package:new_2048/screens/game.dart';

Future<void> main() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          // these are variable
          // for each firebase project
          apiKey: "AIzaSyAirHSLx7pR3JsozlNzzz9TN1TkGGXO4k0",
          authDomain: "flutter2048-82322.firebaseapp.com",
          projectId: "flutter2048-82322",
          storageBucket: "flutter2048-82322.appspot.com",
          messagingSenderId: "283086209153",
          appId: "1:283086209153:web:454ec59fc5b5e74667cd80",
          measurementId: "G-YEZ0CQJWD9"));
  //DefaultFirebaseOptions.currentPlatform,
  //)
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: AuthManager().isLoginBool() ? const Game() : AuthScreen(),
      //home: GoogleSignIn(),
    );
  }
}
