import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis/constants.dart';
import 'package:thesis/model/end_user.dart';
import 'package:thesis/services/database_service.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      EndUser endUser = await DatabaseService().getUser();
      if (endUser.userType == medico) {
        FirebaseAuth.instance.signOut();
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    }
  }

  User getCurrentUser() {
    return auth.currentUser;
  }
}
