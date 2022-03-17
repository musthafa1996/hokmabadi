import 'dart:convert';

import 'package:hokmabadi/config/constants.dart';
import 'package:hokmabadi/models/token.dart';
import 'package:http/http.dart' as http;

class TokenService {
  Future<Token> generateToken() async {
    final url = Uri.parse(
        "$kAscendApiEndpoint/oauth/client_credential/accesstoken?grant_type=client_credentials");
    final response = await http.post(url,
        body:
            "client_id=L1NPNF1mtTHoAPQj6BFixkXvxFaLGL4q&client_secret=xRrMXCnrU4JRUR4K",
        encoding: Encoding.getByName("utf-8"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = Token.fromJson(data);
      return token;
    }

    throw Exception("An error occurred.");
  }
}
