import 'package:firebase_auth/firebase_auth.dart';

/// Repository for Firebase Authentication operations.
///
/// Provides sign up, sign in (email, Google, Apple), sign out,
/// account deletion, and an auth state changes stream.
class AuthRepository {
  /// Creates an [AuthRepository].
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  /// Stream of auth state changes (user or null).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in user, or null.
  User? get currentUser => _auth.currentUser;

  /// Creates a new account with [email] and [password].
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) =>
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Signs in with [email] and [password].
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// Signs in with Google.
  Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    return _auth.signInWithProvider(provider);
  }

  /// Signs in with Apple.
  Future<UserCredential> signInWithApple() async {
    final provider = AppleAuthProvider();
    return _auth.signInWithProvider(provider);
  }

  /// Signs out the current user.
  Future<void> signOut() => _auth.signOut();

  /// Deletes the current user's account.
  ///
  /// The user must have recently authenticated for this to succeed.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Sends a password reset email to [email].
  Future<void> sendPasswordReset({required String email}) =>
      _auth.sendPasswordResetEmail(email: email);
}
