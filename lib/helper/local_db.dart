import 'package:shared_preferences/shared_preferences.dart';

class LocaleDB {
  static String userSignInKey = 'isSignIn';
  static String usernameKey = 'username';
  static String userEmailKey = 'userEmail';

  //Save user Data
  static Future<bool> saveUserAuthStatusDB(bool isSignIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userSignInKey, isSignIn);
  }

  static Future<bool> saveUsernameDB(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(usernameKey, userName);
  }

  static Future<bool> saveUserEmailDB(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, userEmail);
  }

  //Get user Data
  static Future<bool> getUserAuthStatusDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userSignInKey);
  }

  static Future<String> getUsernameDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static Future<String> getUserEmailDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
}
