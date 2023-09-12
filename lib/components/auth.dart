import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:new_2048/const/colors.dart';
import 'package:new_2048/firebase/firebase_auth.dart';
import 'package:new_2048/firebase/google_login.dart';
import 'package:new_2048/screens/game.dart';

class AuthWidget extends StatefulWidget {
  final AuthManager authManager;
  final VoidCallback? onLoginSuccess;

  const AuthWidget({
    Key? key,
    required this.authManager,
    this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Logger logger = Logger();

  Future<dynamic> popUp(String title, String errorMessage) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    await widget.authManager.register(
      context,
      emailController.text,
      passwordController.text,
    );

    emailController.text = '';
    passwordController.text = '';
  }

  Future<void> _login() async {
    widget.authManager.login(
      context,
      emailController.text,
      passwordController.text,
    );

    emailController.text = '';
    passwordController.text = '';
  }

  Future<void> _signInWithGoogle() async {
    // 웹 플랫폼에서만 Firebase Authentication을 사용
    if (kIsWeb) {
      try {
        var check = await signInWithGoogle();
        logger.i('check: $check');
        setState(() {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (widget.onLoginSuccess != null) {
              widget.onLoginSuccess!();
            }
          }
        });
      } catch (e) {
        logger.i('Error signing in with Google: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Game(),
        ));
        setState(() {});
      }
    });
    widget.authManager.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '2048',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
            ),
          ),
          const SizedBox(
            height: 48.0,
          ),
          LoginBox(
            controller: emailController,
            text: 'Email',
            obscureText: false,
          ),
          const SizedBox(
            height: 8.0,
          ),
          LoginBox(
            controller: passwordController,
            text: 'Password',
            obscureText: true,
          ),
          const SizedBox(
            height: 24.0,
          ),
          SizedBox(
            height: 48.0,
            width: 350,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0.0,
              ),
              onPressed: _login,
              // onPressed: () => widget.authManager.login(
              //     context, emailController.text, passwordController.text),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 48.0,
            width: 350,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0.0,
              ),
              onPressed: _register,
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'or',
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 48.0,
            width: 350,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  side: BorderSide(
                    color: textColor,
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                _signInWithGoogle();
              },
              child: const Text(
                'Sign in with Google Account',
                style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginBox extends StatelessWidget {
  const LoginBox({
    super.key,
    required this.controller,
    required this.text,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String text;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: const TextStyle(
            color: textColor,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
