import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // Save user token
  static Future<bool> saveUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  // Get user token
  static Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  // Remove user token
  static Future<bool> removeUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }

  // Save is admin
  static Future<bool> saveIsAdmin(bool isAdmin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isAdmin', isAdmin);
  }

  // Get is admin
  static Future<bool?> getIsAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');
    return isAdmin;
  }
}
