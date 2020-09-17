import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _appUserFromFirebase(User user) {
    //function to use id only
    return user != null ? AppUser(user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User _user = result.user;

      return _appUserFromFirebase(_user);
    } catch (error) {
      print(error.toString());
    }
  }

  Future signUpWithEmailAndPassWord(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User _user = result.user;

      return _appUserFromFirebase(_user);
    } catch (error) {
      print(error.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }
}
