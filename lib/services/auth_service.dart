import 'package:firebase_auth/firebase_auth.dart';
import 'package:wardobe_app/utils/logger.dart';

class AuthService {
  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getting current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email & password
  Future<User?> register(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Setting the display name
        await userCredential.user?.updateDisplayName(name);
        await userCredential.user?.reload();
        user = _auth.currentUser;
      }
      return user;
    } catch (e) {
      logger.e("Error occurred during registration", error: e);
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      logger.e("Error occurred during sign in:", error: e);
      return null;
    }
  }
}
