import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      return cred.user;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();
}