import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AuthManager {
  Logger logger = Logger();
  String errorMessage = '';

  // 회원가입
  Future<bool> register(BuildContext context, String email, String pw) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register Success!'),
          duration: Duration(seconds: 1),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
          duration: const Duration(seconds: 1),
        ),
      );
    }
    return true;
  }

  // 로그인
  Future<bool> login(BuildContext context, String email, String pw) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
          duration: const Duration(seconds: 1),
        ),
      );
    }

    return true;
  }

  // 로그아웃
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // 현제 로그인한 사용자 정보
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // 현제 사용자가 로그인 중인지
  void isLogin() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        logger.i('User is currently signed out!');
      } else {
        logger.i('email: ${user.email}, uid: ${user.uid}');
      }
    });
  }

  // 현재 사용자가 로그인 중인지 bool
  bool isLoginBool() {
    if (currentUser() == null) {
      return false;
    } else {
      return true;
    }
  }
}
