import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '613180324118-3kuh6u1pns0ajm074jc7rglqtl255av5.apps.googleusercontent.com',
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      //
      // if (googleUser == null) return null;

      GoogleSignInAccount? googleUser =
      kIsWeb ? await (_googleSignIn.signInSilently()) : await (_googleSignIn.signIn());

      if (kIsWeb && googleUser == null) googleUser = await (_googleSignIn.signIn());

      if(googleUser == null)return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}