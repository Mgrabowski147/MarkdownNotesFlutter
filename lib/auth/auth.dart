import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<FirebaseUser> loginWithGoogle() async {
  GoogleSignInAccount currentUser = _googleSignIn.currentUser;
  if (currentUser == null) {
    currentUser = await _googleSignIn.signInSilently();
  }
  if (currentUser == null) {
    currentUser = await _googleSignIn.signIn();
    if (currentUser == null) {
      throw('Login Canceled');
    }
  }

  final GoogleSignInAuthentication gAuth = await currentUser.authentication;

  final FirebaseUser user =
      await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
    idToken: gAuth.idToken,
    accessToken: gAuth.accessToken,
  ));

  assert(user != null);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  return user;
}