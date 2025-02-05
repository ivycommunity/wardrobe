import 'package:firebase_auth/firebase_auth.dart';
import 'package:wardobe_app/utils/logger.dart';

class AuthService {
  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getting current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email & password
  Future<User?> register(String email, String password)async{
    try{
      UserCredential userCredential = 
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        );
        return userCredential.user;
    } catch (e) {
      logger.e("Error occurred during registration", error: e);
      return null;
    }
  }
}