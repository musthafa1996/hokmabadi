import 'package:flutter/material.dart';
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/models/token.dart';
import 'package:hokmabadi/repositories/token_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthController({required this.tokenService});

  final TokenService tokenService;

  Token? _token;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<Token> get token async {
    if (!_isLoggedIn) throw AuthException("Unauthenticated.");

    // if (_token == null || _token!.expiresIn == 0) {
    _token = await tokenService.generateToken();
    // }

    return _token!;
  }

  Future<void> checkIfPreviouslySignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.containsKey("authUsername");
  }

  Future<void> login(String username, String password) async {
    if (!(username == AppConfig.authUsername &&
        password == AppConfig.authPassword)) {
      throw AuthException("Invalid username or password provided.");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("authUsername", username);

    _isLoggedIn = true;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
