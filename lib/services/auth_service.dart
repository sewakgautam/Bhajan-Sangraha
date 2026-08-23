import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import 'bookmark_service.dart';
import 'hive_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  fb.User? get currentUser => _auth.currentUser;

  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  Future<fb.User?>? _signInInFlight;

  /// Returns the signed-in user, or null if the user cancelled the
  /// Google account picker. Throws on a real failure (network, etc.) —
  /// the caller is responsible for showing a snackbar.
  ///
  /// google_sign_in throws `sign_in_already_in_progress` if `signIn()` is
  /// called again before a prior call has finished — easy to trigger with a
  /// quick double-tap on the Sign In button, since nothing disables it while
  /// the native account picker is loading. That second call would fail
  /// immediately and show an error snackbar moments before the first call
  /// succeeds, flashing "Sign-in failed" right before "Signed in". Instead
  /// of starting a second native flow, concurrent callers share the one
  /// already in flight.
  Future<fb.User?> signInWithGoogle() {
    return _signInInFlight ??=
        _signInWithGoogleOnce().whenComplete(() => _signInInFlight = null);
  }

  Future<fb.User?> _signInWithGoogleOnce() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await HiveService.instance.setUserSession(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    }
    return user;
  }

  Future<void> signOut() async {
    BookmarkService.instance.clearInMemoryCache();
    await _googleSignIn.signOut();
    await _auth.signOut();
    await HiveService.instance.clearUserSession();
  }
}
