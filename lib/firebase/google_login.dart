import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<UserCredential> signInWithGoogle() async {
//   GoogleAuthProvider googleProvider = GoogleAuthProvider();

//   googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
//   googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

//   return await FirebaseAuth.instance.signInWithPopup(googleProvider);
// }

Future<User?> signInWithGoogle() async {
  String? name, imageUrl, userEmail, uid;
  // Initialize Firebase
  await Firebase.initializeApp();
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  // The `GoogleAuthProvider` can only be
  // used while running on the web
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);
    user = userCredential.user;
  } catch (e) {
    print(e);
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    print("name: $name");
    print("userEmail: $userEmail");
    print("imageUrl: $imageUrl");
  }
  return user;
}
