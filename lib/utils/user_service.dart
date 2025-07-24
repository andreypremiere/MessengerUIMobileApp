import 'dart:convert';

import 'package:messenger_ui/models/user.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  User? _currentUser;

  void clear() {
    _currentUser = null;
  }

  User? get currentUser => _currentUser;

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = jsonEncode(user.toJson());
    await prefs.setString('user', userJsonString);
    _currentUser = user;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      _currentUser = User.fromJson(jsonDecode(userString));
    } else {
      _currentUser = null;
    }
  }
}
