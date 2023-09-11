import 'package:flutter/material.dart';
import 'package:new_2048/components/auth.dart';
import 'package:new_2048/const/colors.dart';
import 'package:new_2048/firebase/firebase_auth.dart';
import 'package:new_2048/screens/game.dart';

class AuthScreen extends StatelessWidget {
  final authManager = AuthManager();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: AuthWidget(
          authManager: authManager,
          onLoginSuccess: () {
            // 로그인 성공 시 다음 화면으로 이동
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Game(),
            ));
          },
        ),
      ),
    );
  }
}
