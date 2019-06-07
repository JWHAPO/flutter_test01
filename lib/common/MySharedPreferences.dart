import 'package:shared_preferences/shared_preferences.dart';


class MySharedPreferences{
  final String _keyFirebaseToken = "firebaseToken";

  // Firebase Token get Value
  Future<String> getFirebaseToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirebaseToken) ?? '';
  }

  // Firebase Token set Value
  Future<bool> setFirebaseToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyFirebaseToken, token);
  }
}