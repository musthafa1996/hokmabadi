import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import 'package:http/http.dart' as http;
import '../../controllers/auth_controller.dart';
import '../../models/agora_token.dart';

class AgoraRepository {
  AgoraRepository({required this.authController});

  final AuthController authController;

  Future<AgoraToken> generateToken({
    required int appointmentId,
    required String channel,
    required String location,
    required int patientId,
    required String patientName,
    required String providerId,
    required String? note,
  }) async {

    final token = authController.token;


    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };


    final body = <String, dynamic>{
      "uid": "0",
      "channel_name": channel,
      "role": 'host',
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "name": patientName,
      "note": note,
      "location": location,
    };

    if (note?.isNotEmpty ?? false) {
      note = note!.replaceAll(RegExp(r"[\n]+"), "");
      note = note.replaceAll(RegExp(r"[\s]*Insurance.*"), "");
      body['note'] = note;
    }

    final response =
        await http.post(Uri.parse("$kBaseUrl/admin/virtual-call/token"), body: jsonEncode(body) , headers: headers);


    debugPrint(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = AgoraToken.fromJson(Map<String, dynamic>.from(data));
      return token;
    }

    throw Exception("An error occurred.");
  }
}
