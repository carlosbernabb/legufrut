import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random string used as the Apple nonce.
String _generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String _sha256ofString(String input) =>
    sha256.convert(utf8.encode(input)).toString();

Future<UserCredential> appleSignIn() async {
  // Web: keep Firebase's popup-based OAuth flow.
  if (kIsWeb) {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    return FirebaseAuth.instance.signInWithPopup(provider);
  }

  // Native Apple platforms (iOS/macOS): use Sign in with Apple with an explicit
  // nonce. Firebase rejects the credential with `invalid-credential` /
  // `missing-or-invalid-nonce` when the nonce isn't supplied this way, which is
  // the bug that caused Apple sign in to fail on iPhone.
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // Apple only returns the user's name on the very first authorization, so
    // persist it to the Firebase profile before it's lost.
    final displayName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().where((p) => p.isNotEmpty).join(' ').trim();
    final currentName = userCredential.user?.displayName;
    if (displayName.isNotEmpty &&
        (currentName == null || currentName.isEmpty)) {
      await userCredential.user?.updateDisplayName(displayName);
    }

    return userCredential;
  }

  // Other platforms (e.g. Android) fall back to the provider-based flow.
  final provider = AppleAuthProvider()
    ..addScope('email')
    ..addScope('name');
  return FirebaseAuth.instance.signInWithProvider(provider);
}
