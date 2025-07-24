import 'package:provider/provider.dart' as provider;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as sev_storage;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  String? _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
  }

  String? get token => _token;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    _token = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _token = null;
  }

  bool get isLoggedIn => _token != null;
}

