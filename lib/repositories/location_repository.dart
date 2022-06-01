import 'dart:convert';

import 'package:hokmabadi/config/constants.dart';
import 'package:hokmabadi/models/location.dart';
import 'package:http/http.dart' as http;
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';

class LocationRepository {
  LocationRepository({required this.authController});

  final AuthController authController;

  Future<Location> retrieve(String id) async {
    final token = authController.token;

    final url =
        Uri.parse("$kBaseUrl/admin/locations");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Organization-ID': AppConfig.ascendOrganizationId,
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Location> locations = (data['data'] as List)
          .map((e) => Location.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return locations.firstWhere(
              (location) => location.uid == id
      );

    }

    throw Exception("An error occurred.");
  }
}
