import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  final String _keyFirebaseToken = "firebaseToken";
  final String _keyCookie = "cookie";
  final String _keyBadgeCountForEvent = "badgeCountForEvent";
  final String _keyIsAgreeOfPushMessaging = "isAgreeOfPushMessaging";

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

  // Cookie get Value
  Future<String> getCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCookie) ?? '';
  }

  // Cookie set Value
  Future<bool> setCookie(String cookie) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyCookie, cookie);
  }

  // adgeCountForEvent get Value
  Future<int> getBadgeCountForEvent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyBadgeCountForEvent) ?? 0;
  }

  // adgeCountForEvent set Value
  Future<bool> setBadgeCountForEvent(int badgeCountForEvent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_keyBadgeCountForEvent, badgeCountForEvent);
  }

  Future<bool> getIsAgreeOfPushMessaging() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAgreeOfPushMessaging) ?? false;
  }

  Future<bool> setIsAgreeOfPushMessaging(bool isAgreeOfPushMessaging) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyIsAgreeOfPushMessaging, isAgreeOfPushMessaging);
  }
}
