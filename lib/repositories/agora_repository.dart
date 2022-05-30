import 'dart:convert';

import 'package:flutter/material.dart';
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

    final token = authController.token;


    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };


    final body = <String, dynamic>{
      "appointment_id": "1",
      "channel_name": "Appointment for 1",
      "location": "THDC Office 2",
      "name": "John Doe",
      "patient_id": "360480",
      "role": 'host',
      "uid": "510",
    };


    if (note?.isNotEmpty ?? false) {
      note = note!.replaceAll(RegExp(r"[\n]+"), "");
      note = note.replaceAll(RegExp(r"[\s]*Insurance.*"), "");
      body['note'] = note;
    }

    final response =
        await http.post(Uri.parse("$kStagingUrl/agora/token"), body: jsonEncode(body) , headers: headers);


    debugPrint(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = AgoraToken.fromJson(Map<String, dynamic>.from(data));
      return token;
    }

    throw Exception("An error occurred.");
  }
}
