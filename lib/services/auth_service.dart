// Required imports for Firebase Authentication, Google Sign In, and logging
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wardobe_app/utils/logger.dart';

/// AuthService handles all authentication-related operations including email/password
/// registration, sign-in, Google authentication, and sign-out functionality.
class AuthService {
  // Initialize Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Initialize Google Sign In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Returns the currently authenticated user, if any
  /// Returns null if no user is signed in
  User? get currentUser => _auth.currentUser;

  /// Registers a new user with email and password
  /// @param name - The display name for the new user
  /// @param email - The email address for registration
  /// @param password - The user's chosen password
  /// @returns Future<User?> - The created user object, or null if registration fails
  Future<User?> register(String name, String email, String password) async {
    try {
      // Create new user account with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Update the user's display name after successful account creation
        await userCredential.user?.updateDisplayName(name);
        // Reload user data to ensure we have the latest information
        await userCredential.user?.reload();
        user = _auth.currentUser;
      }
      return user;
    } catch (e) {
      // Log any errors that occur during registration
      logger.e("Error occurred during registration", error: e);
      return null;
    }
  }

  /// Signs in an existing user with email and password
  /// @param email - The user's email address
  /// @param password - The user's password
  /// @returns Future<User?> - The signed-in user object, or null if sign-in fails
  Future<User?> signIn(String email, String password) async {
    try {
      // Attempt to sign in with provided credentials
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Log any errors that occur during sign-in
      logger.e("Error occurred during sign in:", error: e);
      return null;
    }
  }

  /// Handles Google Sign In authentication process
  /// Shows account picker every time and manages OAuth flow
  /// @returns Future<User?> - The signed-in user object, or null if sign-in fails/cancelled
  Future<User?> signInWithGoogle() async {
    try {
      // Configure Google Sign In with specific options
      final GoogleSignIn googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard, // Forces account picker dialog
        scopes: ['email'], // Request email scope only
        forceCodeForRefreshToken: true, // Ensure fresh authentication
      );

      // Sign out of any existing Google session to force account picker
      await googleSignIn.signOut();

      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled the sign-in flow

      // Get authentication details from Google Sign In
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create Firebase credential from Google authentication tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // Log any errors that occur during Google sign-in
      logger.e("Error occurred during sign in", error: e);
      return null;
    }
  }

  /// Signs out the current user from both Firebase and Google
  /// @returns Future<void>
  Future<void> signOut() async {
    // Sign out from Firebase
    await _auth.signOut();
    // Sign out from Google to clear any remaining session
    await _googleSignIn.signOut();
  }
}