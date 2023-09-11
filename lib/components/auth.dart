import 'package:flutter/material.dart';
import 'package:new_2048/const/colors.dart';
import 'package:new_2048/firebase/firebase_auth.dart';

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
    bool success = await widget.authManager.register(
      emailController.text,
      passwordController.text,
    );
    if (success) {
      setState(() {
        popUp('Registration Success', 'Registration completed. Please login.');
      });
    } else {
      setState(() {
        popUp('Registration Error', widget.authManager.errorMessage);
      });
    }

    emailController.text = '';
    passwordController.text = '';
  }

  Future<void> _login() async {
    bool success = await widget.authManager.login(
      emailController.text,
      passwordController.text,
    );
    if (success) {
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      }
    } else {
      setState(() {
        popUp('Login Error', widget.authManager.errorMessage);
      });
    }

    emailController.text = '';
    passwordController.text = '';
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
              ),
              onPressed: _login,
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
