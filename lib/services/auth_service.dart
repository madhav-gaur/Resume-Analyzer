import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = user.user?.uid;
    if (uid == null) return user;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
    });

    return user;
  }

  Future<UserCredential?> signin({
    required String email,
    required String password,
  }) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }
}
