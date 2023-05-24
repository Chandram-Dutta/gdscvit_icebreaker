import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  User? get currentUser;
  Future<void> signInWithGoogle();
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
