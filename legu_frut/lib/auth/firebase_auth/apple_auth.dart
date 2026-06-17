import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential> appleSignIn() async {
  final provider = AppleAuthProvider()
    ..addScope('email')
    ..addScope('name');

  if (kIsWeb) {
    return FirebaseAuth.instance.signInWithPopup(provider);
  }

  return FirebaseAuth.instance.signInWithProvider(provider);
}
