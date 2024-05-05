import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw error;
    }
  }
}
