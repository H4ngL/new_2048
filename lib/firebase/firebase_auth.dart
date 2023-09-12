import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthManager {
  Logger logger = Logger();
  String errorMessage = '';

  AuthManager() {
    //isLogin();
  }

  // 회원가입
  Future<bool> register(String email, String pw) async {
    if (email.isEmpty || pw.isEmpty) {
      errorMessage = 'Please enter your email and password.';
      return false;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
        return false;
      } else if (e.code == 'weak-password') {
        errorMessage = 'Please enter a password with at least 6 characters.';
        return false;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }

    return true;
  }

  // 로그인
  void login(String email, String pw) async {
    if (email.isEmpty || pw.isEmpty) {
      errorMessage = 'Please enter your email and password.';
      return;
    }
    print('email: $email, pw: $pw');

    try {
      print('in try');
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pw,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
        print(errorMessage);
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        print(errorMessage);
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
        print(errorMessage);
      }
    } catch (e) {
      errorMessage = e.toString();
      print(e);
    }
  }

  // 로그아웃
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // 회원가입, 로그인 시 사용자 영속
  void authPersistence() async {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
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
