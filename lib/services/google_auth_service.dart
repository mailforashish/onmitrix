import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  late final GoogleSignIn _googleSignIn;

  factory GoogleAuthService() {
    return _instance;
  }

  GoogleAuthService._internal() {
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // Replace with your web client ID
        scopes: ['email'],
      );
    } else {
      _googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );
    }
  }

  Future<String?> getGoogleEmail() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        await _googleSignIn.signOut(); // Sign out immediately as we only need email
        return account.email;
      }
      return null;
    } catch (e) {
      print('Error getting Google email: $e');
      return null;
    }
  }
}