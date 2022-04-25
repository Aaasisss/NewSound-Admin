import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:newsound_admin/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';

class AuthServive {
  //a stream to  listen to the currently logged in user and react accordingly
  final userStream = FirebaseAuth.instance.authStateChanges();
  //to check authentication state in some events
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signInWithGoogle() async {
    try {
      //brings up a window on the user's actual device to sign in with google
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      //provides google user authentication object
      final googleAuth = await googleUser.authentication;

      //create credential for firebase auth with GoogleAuthProvidor from firebase using accessToken and idToken
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //pass the credential to sign in with signInWithCredential
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
