import 'dart:convert';

import 'package:hokmabadi/config/constants.dart';
import 'package:hokmabadi/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';

class AppointmentRepository {
  AppointmentRepository({required this.authController});

  final AuthController authController;

  Future<List<Appointment>> retrieveUpcoming(String patientId) async {
    final token = await authController.token;
    final now = DateTime.now();

    final url = Uri.parse("$kBaseUrl/admin/patients/$patientId/appointments")
            .replace(
        queryParameters: {"moment": "upcoming"});

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Appointment> appointments = (data['data'] as List)
          .map((e) => Appointment.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      appointments.sort((a, b) => a.start.compareTo(b.start));
      return appointments;
    }

    throw Exception("An error occurred.");
  }
}
