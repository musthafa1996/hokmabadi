import 'dart:convert';

import 'package:hokmabadi/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:hokmabadi/controllers/auth_controller.dart';
import 'package:hokmabadi/models/agora_token.dart';

class AgoraRepository {
  AgoraRepository({required this.authController});

  final AuthController authController;

  Future<AgoraToken> generateToken({
    required String appointmentId,
    required String channel,
    required String location,
    required String patientId,
    required String patientName,
    required String providerId,
    required String? note,
    required DateTime start,
  }) async {
    final body = <String, dynamic>{
      "appointment_id": appointmentId,
      "channel_name": channel,
      "location": location,
      "name": patientName,
      "patient_id": patientId,
      "role": 'host',
      "start": start.toIso8601String(),
      "uid": "0",
    };

    if (note?.isNotEmpty ?? false) {
      note = note!.replaceAll(RegExp(r"[\n]+"), "");
      note = note.replaceAll(RegExp(r"[\s]*Insurance.*"), "");
      body['note'] = note;
    }

    final response =
        await http.post(Uri.parse("$kVirtualApiEndpoint/token"), body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = AgoraToken.fromJson(Map<String, dynamic>.from(data));
      return token;
    }

    throw Exception("An error occurred.");
  }
}
