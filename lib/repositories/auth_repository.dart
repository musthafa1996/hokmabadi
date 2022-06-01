import 'dart:convert';
import '../../utils/http_client.dart';
import '../config/constants.dart';
import '../models/authenticated_response.dart';

class AuthRepository {
  AuthRepository({required this.httpClient});

  final AppHttpClient httpClient;




  Future<AuthenticatedResponse> signIn(String email,String password) async {
    final body = {
      "email": email,
      "password": password
    };

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };


    final url = Uri.parse("$kBaseUrl/admin/login");

    final response = await httpClient.post(url, body: jsonEncode(body), headers: headers);
    final Map<String, dynamic> json = jsonDecode(response.body);

    if (!(response.statusCode == 200 || response.statusCode == 204)) {
      final data = jsonDecode(response.body);
      final message = data["message"] ?? "An error occurred while sending verification code.";
      throw message;
    }

    final Map<String, dynamic> data = json['data'];
    final authenticatedResponse = AuthenticatedResponse.fromJson(data);
    return authenticatedResponse;

  }

}
