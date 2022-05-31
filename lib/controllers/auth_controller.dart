import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/models/authenticated_response.dart';
import 'package:hokmabadi/models/token.dart';
import 'package:hokmabadi/repositories/auth_repository.dart';
import 'package:hokmabadi/repositories/token_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/http_client.dart';
import 'dart:convert';

import '../config/constants.dart';




class AuthController extends ChangeNotifier {
  AuthController({required this.authRepository});

  final AuthRepository authRepository;


  String? _token;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String get token {
    if (!isLoggedIn) throw AuthException("Unauthenticated.");
    return _token!;
  }


  Future<void> checkIfPreviouslySignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.containsKey("authUsername");
  }

  Future<void> login(String username, String password) async {

    final AuthenticatedResponse authResponse = await Modular.get<AuthRepository>().signIn(username, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", authResponse.token);
    _token = authResponse.token;
    _isLoggedIn = true;

  }


  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _token = null;
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
