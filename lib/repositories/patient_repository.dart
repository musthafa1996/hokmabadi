import 'dart:convert';

import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/config/constants.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';
import 'package:hokmabadi/models/patient.dart';
import 'package:http/http.dart' as http;

class PatientRepository {
  PatientRepository({
    required this.authController,
  });

  final AuthController authController;

  Future<List<Patient>> search({
    required String? firstName,
    required String? lastName,
  }) async {
    if ((firstName?.isEmpty ?? true) && (lastName?.isEmpty ?? true)) {
      throw Exception("At least one of first name or last name is required.");
    }

    final token = await authController.token;
    final filters = <String>[];

    if(firstName?.isNotEmpty ?? false) {
      filters.add("firstName~=$firstName");
    }
    if(lastName?.isNotEmpty ?? false) {
      filters.add("lastName~=$lastName");
    }

    final filtersString = filters.join(",");

    final url = Uri.parse("$kAscendApiEndpoint/ascend-gateway/api/v1/patients")
        .replace(queryParameters: {"filter": filtersString});
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Organization-ID': AppConfig.ascendOrganizationId,
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final patients = (data['data'] as List)
          .map((e) => Patient.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return patients;
    }

    throw Exception("An error occurred.");
  }

  Future<Patient> retrieve(String id) async {
    final token = await authController.token;

    final url =
        Uri.parse("$kAscendApiEndpoint/ascend-gateway/api/v1/patients/$id");
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Organization-ID': AppConfig.ascendOrganizationId,
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final patient = Patient.fromJson(Map<String, dynamic>.from(data['data']));
      return patient;
    }

    throw Exception("An error occurred.");
  }
}
