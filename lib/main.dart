import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:new_2048/firebase/firebase_auth.dart';
import 'package:new_2048/screens/auth_screen.dart';
import 'package:new_2048/firebase_options.dart';
import 'package:new_2048/screens/game.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
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
